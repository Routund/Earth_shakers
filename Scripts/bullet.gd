extends CharacterBody3D

var time = 2
var damage = 1
var speed = 30
var gravity_scale = 0.025
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.gun == 0:
		speed = 20
		time = 3
		hide()
		$Timer2.start(0.01)
	elif Global.gun == 1:
		speed = 60
		time = 0.25
	$Timer.start(time)

func _process(delta: float) -> void:
	if Gravity.check_ground(position)[1]:
		queue_free()
	velocity = speed * -transform.basis.z
	
	move_and_slide()

func _on_timer_timeout():
	queue_free()


func _on_timer_2_timeout() -> void:
	show()
	speed = 100
