extends CharacterBody3D

var damage = 1
const SPEED = 5
var gravity_scale = 0.025
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start(12)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Gravity.check_ground(position)[1]:
		queue_free()
	transform = Gravity.rotate_object(position,transform)
	var accel = Gravity.gravitate(position)
	velocity = -accel[0] * gravity_scale * SPEED - transform.basis.z * SPEED
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()
