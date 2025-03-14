extends Node3D

var spawning = true
var health = 10
var speed = 5
var velocity = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.num_ships +=1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform = Gravity.rotate_object(position,transform)
	velocity = speed * -transform.basis.x
	position += velocity * delta
	if spawning == true:
		spawning = false
		transform = transform.rotated(transform.basis.y, randf_range(0,2*PI))
	

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group('bullet'):
		damage(area.get_parent().damage)
		area.get_parent().queue_free()
	pass # Replace with function body.

func damage(value):
	health -= value
	if health <= 0:
		Global.num_ships -=1
		queue_free()
