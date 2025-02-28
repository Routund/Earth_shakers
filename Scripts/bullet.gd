extends CharacterBody3D

var time = 0.25
var damage = 1
var speed = 60
var gravity_scale = 0.025
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start(time)

func _process(delta: float) -> void:
	if Gravity.check_ground(position)[1]:
		queue_free()
	velocity = speed * -transform.basis.z
	
	move_and_slide()

func _on_timer_timeout():
	queue_free()
