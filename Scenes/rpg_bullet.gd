extends CharacterBody3D

var time = 2
var damage = 10
var speed = 80
var gravity_scale = 0.025
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start(time)

func _process(delta: float) -> void:
	if Gravity.check_ground(position)[1]:
		damage = 5
		$explosion/CollisionShape3D.disabled = false
		await get_tree().create_timer(1).timeout
		queue_free()
	velocity = speed * -transform.basis.z
	move_and_slide()

func _on_timer_timeout():
	queue_free()
