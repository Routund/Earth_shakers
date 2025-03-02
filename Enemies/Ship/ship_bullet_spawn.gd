extends Node3D

var bullet_rotation = -45
var bullet = load("res://Enemies/enemy_bullet.tscn")
var instance
var randtime = randf_range(0,1)+2
@onready var player = self.get_parent().get_parent().get_parent().find_child('player')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$bullet_timer.start(randtime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		pass

func _on_bullet_timer_timeout() -> void:
	if (player.global_position - global_position).length() <= 14:
		instance = bullet.instantiate()
		instance.position = global_position 
		instance.transform.basis = global_transform.basis
		player.get_parent().add_child(instance)
	$bullet_timer.start(randtime)
