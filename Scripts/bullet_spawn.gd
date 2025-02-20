extends Node3D

var riffle = false
var shotgun = true
var bullet_rotation = -45
var bullet = load("res://Scenes/bullet.tscn")
var instance
signal shot(power : float)
@onready var player = $"../../../.."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		if riffle:
			instance = bullet.instantiate()
			instance.position = global_position 
			instance.transform.basis = global_transform.basis
			player.get_parent().add_child(instance)
			shot.emit(0.05)
		if shotgun:
			for i in range(5):
				bullet_rotation += 3
				instance = bullet.instantiate()
				instance.transform = global_transform
				instance.rotation += Vector3(deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)))
				instance.position = global_position
				player.get_parent().add_child(instance)
			bullet_rotation = -6
			shot.emit(0.2)
	pass
