extends Node3D

@onready var player_scene = preload("res://Player/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	for i in MultiplayerManager.players.keys():
		var current_player = player_scene.instantiate()
		current_player.position = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)).normalized()
		
		if MultiplayerManager.players[i]["id"] != null:
			current_player.name = str(MultiplayerManager.players[i]["id"])
		else:
			current_player.name = "1"
		add_child(current_player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
