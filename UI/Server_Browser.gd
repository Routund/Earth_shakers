extends Panel

signal found_server
signal removed_server

@onready var broadcast_timer : Timer = $Timer
var broadcaster : PacketPeerUDP
@export var broadcastPort : int = 4315
@export var broadcast_address : String = '192.168.1.255'
var broadcasting = false

var listener : PacketPeerUDP
@export var listenPort = 4316

var server_preload = preload("res://UI/ip_address.tscn")
@onready var VBox = $ScrollContainer/VBOX
var servers : Array = []

var room_info = {
	"Name" : "",
	"Player Count" : 1
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up_listen()
	broadcast_timer.connect('timeout',broadcast_time_out) 
	pass # Replace with function body.

func set_up_listen():
	listener = PacketPeerUDP.new()
	var ok = listener.bind(listenPort)
	
	if ok == OK:
		print("Bound to listen port: " + str(listenPort))
	else:
		print("Failed to bind Listen")
		ok = listener.bind(listenPort+1)
		if ok != OK:
			print("uh oh")
		else:
			print("Bound to listen port: " + str(listenPort+1))

func set_up_broadcast():
	room_info["Name"] = str($"../Name_input".text) + '\'s server'
	room_info["Player Count"] = 1
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcast_address, listenPort)
	
	broadcast_timer.start()
	
	var ok = broadcaster.bind(broadcastPort)
	
	if ok == OK:
		print("Bound to broadcast port: " + str(broadcastPort))
		broadcasting = true
	else:
		print("Failed to bind broadcaster")
	pass

func broadcast_time_out():
	print("Broadcasting")
	room_info["Player Count"] = MultiplayerManager.players.size()
	var data = JSON.stringify(room_info)
	var packet = data.to_utf8_buffer()
	broadcaster.put_packet(packet)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !broadcasting:
		if listener.get_available_packet_count() > 0:
			var serverip = listener.get_packet_ip()
			var serverport = listener.get_packet_port()
			var bytes = listener.get_packet()
			var data = bytes.get_string_from_utf8()
			print("recieved")
			
			if data == "CLOSED":
				if serverip in servers:
					VBox.get_node(str(servers.find(serverip))).queue_free()
					servers.erase(serverip)
			elif serverip != "":
				var server_info = JSON.parse_string(data)
				if serverip in servers:
					var affected = VBox.get_node(str(servers.find(serverip)))
					affected.server_name = server_info["Name"]
					affected.player_count = server_info["Player Count"]
					affected.refresh()
				else:
					var new_server = server_preload.instantiate()
					new_server.ip = serverip
					new_server.server_name = server_info["Name"]
					VBox.add_child(new_server)
					new_server.name = str(len(servers))
					new_server.refresh()
					servers.append(serverip)
					
					new_server.connect("button_up",get_parent().join_to)
		pass

func _exit_tree() -> void:
	if listener != null:
		listener.close()
	if broadcaster != null:
		stop_broadcast()
		broadcaster.close()

func stop_broadcast():
	$Timer.stop()
	broadcasting = false
	broadcaster.put_packet(("CLOSED").to_utf8_buffer())
	broadcaster.close()
