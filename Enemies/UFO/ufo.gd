extends Node3D

var flag = true
var moving = false
var health = 10
@onready var animator = get_node("AnimationPlayer")

var alien_preload = preload("res://Enemies/Alien/hurricane_kick.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.num_ufos += 1
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if flag:
		look_at(Vector3(0,0,0))
		rotate_object_local(Vector3(1,0,0).normalized(), PI/2)
		flag = false



func _on_despawn_timeout() -> void:
	moving = true
	Global.num_ufos -= 1
	queue_free()

func damage(value):
	health -= value
	if health <= 0:
		Global.num_ufos -= 1
		queue_free()


func _on_area_3_dufo_area_entered(area: Area3D) -> void:
	if area.is_in_group('bullet'):
		damage(area.get_parent().damage)
		area.get_parent().queue_free()


func make_alien():
	if Global.num_slims < Global.max_slims and !moving:
		animator.play("beam")
		$Spawn_Alien.start()



func _on_spawn_alien_timeout() -> void:
	var alien = alien_preload.instantiate()
	get_parent().add_child(alien)
	alien.position = position.normalized()*15


func _on_make_alien_timeout() -> void:
	make_alien()
	pass # Replace with function body.
