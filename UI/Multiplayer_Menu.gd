extends Control

@export var address = "127.0.0.1"
@export var port = 4313

var scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_error)
	$HBoxContainer/Start.visible = false
	$HBoxContainer/Host.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func peer_connected(id):
	print("Player connected - " + str(id))

func peer_disconnected(id):
	print("Player disconnected - " + str(id))
	get_tree().root.remove_child(scene)
	get_parent().visible = true
	$HBoxContainer/Host.visible = true
	$HBoxContainer/Join.visible = true
	$HBoxContainer/Start.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	MultiplayerManager.players.clear()

func connected_to_server():
	print("Connected to server")
	send_player_info.rpc_id(1,multiplayer.get_unique_id(),"")
	
func connection_error():
	print("Connected Failed")

func _on_host_button_up() -> void:
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port,2)
	if error != OK:
		print("Unable to host" + str(error))
	else:
		peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
		multiplayer.set_multiplayer_peer(peer)
		$HBoxContainer/Join.visible = false
	print("Server Created")
	$HBoxContainer/Start.visible = true
	send_player_info(multiplayer.get_unique_id(),"")
	pass # Replace with function body.


func _on_join_button_up() -> void:
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_client(address,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	$HBoxContainer/Start.visible = false
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


func _on_start_button_up() -> void:
	start_multiplayer.rpc()
	pass # Replace with function body.

@rpc("any_peer","call_local")
func start_multiplayer():
	Global.networking = true
	get_parent().visible = false
	scene = load("res://Planet/multiplayer_planet.tscn").instantiate()
	get_tree().root.add_child(scene)

@rpc("any_peer")
func send_player_info(id,username):
	if !MultiplayerManager.players.has(id):
		MultiplayerManager.players[id] = {
			"id": id,
			"name": username,
			"health": 100,
		}
		
		print(id)
		
		if multiplayer.is_server():
			for i in MultiplayerManager.players.keys():
				send_player_info.rpc(i,MultiplayerManager.players[i].name)
	
