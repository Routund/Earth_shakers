extends Node3D

var damage = 1
const SPEED = 4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start(0.9)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0,-SPEED) * delta
	if Gravity.check_ground(position)[1]:
		queue_free()



func _on_timer_timeout() -> void:
	queue_free()
