extends CharacterBody3D

var gravity_scale = 18
const SPEED = 40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Gravity.check_ground(position)[1]:
		queue_free()
	transform = Gravity.rotate_object(position,transform)
	var accel = Gravity.gravitate(position)
	move_and_slide()
	velocity = accel[0] * delta * gravity_scale
	position += transform.basis * Vector3(0,velocity.y,-SPEED) * delta

func _on_timer_timeout() -> void:
	queue_free()
