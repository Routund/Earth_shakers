extends Node3D

var health = 25
var speed = 50
var velocity = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform = Gravity.rotate_object(position,transform)
	velocity = speed * -transform.basis.x
	position += velocity * delta
