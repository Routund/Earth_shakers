extends Node

var players = {}
var bullet_id = 0

@rpc("any_peer","call_local")
func disconnect_all():
	if multiplayer.is_server():
		for i in MultiplayerManager.players.keys():
			multiplayer.multiplayer_peer.disconnect_peer(i)
