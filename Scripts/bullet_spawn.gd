extends Node3D

var scrolltick = 0
var gun = 0
var bullet_rotation = -45
var bullet = load("res://Scenes/bullet.tscn")
var instance
var equipped = true
signal shot(power : float)
@onready var player = $"../../../.."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('scroll'):
		scrolltick += 1
		gun += 1
		$scroll.start(0.5)
	if Input.is_action_just_pressed('scrolld'):
		scrolltick += 1
		gun -= 1
		$scrolld.start(0.5)
	if Input.is_action_just_pressed("shoot"):
		if gun == 0:
			instance = bullet.instantiate()
			instance.position = global_position 
			instance.transform.basis = global_transform.basis
			player.get_parent().add_child(instance)
			shot.emit(0.05)
		if gun == 1:
			for i in range(6):
				bullet_rotation += 3
				instance = bullet.instantiate()
				instance.transform = global_transform
				instance.rotation += Vector3(deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)))
				instance.position = global_position
				player.get_parent().add_child(instance)
			bullet_rotation = -6
			shot.emit(0.05)


func _on_scroll_timeout() -> void:
	gun -= (scrolltick-1)
	scrolltick = 0
	if gun > 1:
		gun = 0


func _on_scrolld_timeout() -> void:
	gun += (scrolltick-1)
	scrolltick = 0
	if gun < 0:
		gun = 1
