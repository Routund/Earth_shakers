extends Node3D

var cooldown = false
var scrolltick = 0
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
	if Input.is_action_just_pressed('scroll'):
		scrolltick += 1
		Global.gun += 1
		$scroll.start(0.1)
	if Input.is_action_just_pressed('scrolld'):
		scrolltick += 1
		Global.gun -= 1
		$scrolld.start(0.1)
	if Input.is_action_pressed("shoot") and not cooldown:
		if Global.gun == 0:
			instance = bullet.instantiate()
			instance.position = $"../../ak_spawn".global_position 
			instance.transform.basis = global_transform.basis
			player.get_parent().add_child(instance)
			shot.emit(0.05)
			cooldown = true
			$shoot_cooldown.start(0.1)
		elif Global.gun == 1:
			for i in range(6):
				bullet_rotation += 3
				instance = bullet.instantiate()
				instance.transform = global_transform
				instance.rotation += Vector3(deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)))
				instance.position = global_position
				player.get_parent().add_child(instance)
			bullet_rotation = -6
			shot.emit(0.05)
			cooldown = true
			$shoot_cooldown.start(1)


func _on_scroll_timeout() -> void:
	Global.gun -= (scrolltick-1)
	scrolltick = 0
	if Global.gun > 1:
		Global.gun = 0


func _on_scrolld_timeout() -> void:
	Global.gun += (scrolltick-1)
	scrolltick = 0
	if Global.gun < 0:
		Global.gun = 1


func _on_shoot_cooldown_timeout() -> void:
	cooldown = false
