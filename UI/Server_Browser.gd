extends Panel

signal found_server
signal removed_server

@onready var broadcast_timer : Timer = $Timer
var broadcaster : PacketPeerUDP
@export var broadcastPort : int = 4315
@export var broadcast_address : String = '10.1.34.255'

var listener : PacketPeerUDP
@export var listenPort = 4314


var room_info = {
	"Name" : "",
	"Player Count" : 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	broadcast_timer.connect('timeout',broadcast_time_out) 
	pass # Replace with function body.

func set_up_listen():
	listener = PacketPeerUDP.new()
	var ok = listener.bind(listenPort)
	
	if ok == OK:
		print("Bound to listen port: " + str(listenPort))
	else:
		print("Failed to bind Listen")

func set_up_broadcast():
	room_info["Name"] = str($"../Name_input".text) + '\'server'
	room_info["Player Count"] = MultiplayerManager.players.size()
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address('10.1.34.255', listenPort)
	
	broadcast_timer.start()
	
	var ok = broadcaster.bind(broadcastPort)
	
	if ok == OK:
		print("Bound to broadcast port: " + str(broadcastPort))
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
	if listener.get_available_packet_count() > 0:
		var serverip = listener.get_packet_ip()
		var serverport = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_utf8()
	pass

func _exit_tree() -> void:
	if listener != null:
		listener.close()
	if broadcaster != null:
		broadcaster.close()

func stop_broadcast():
	$Timer.stop()
