extends Control

var normal_offset
@onready var meter = $Health_meter
var health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_client_health = 100
	normal_offset = meter.position.y
	health = Global.player_client_health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	meter.material.set("shader_parameter/level",(float(health) / 100))

	pass

func change_health(value):
	Global.player_client_health -= value
	var tween = create_tween()
	tween.tween_property(self,"health",Global.player_client_health,0.5)
	if Global.player_client_health <= 0:
		if !Global.networking:
			get_tree().reload_current_scene()
		else:
			MultiplayerManager.disconnect_all.rpc()
