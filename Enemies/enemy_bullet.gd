extends CharacterBody3D

var damage = 5
const SPEED = 6
var gravity_scale = 0.025
@onready var player = self.get_parent().find_child('player')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start(3)
	look_at(player.position + player.position.normalized())

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Gravity.check_ground(position)[1]:
		queue_free()
	velocity = SPEED * -transform.basis.z
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()
