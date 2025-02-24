extends Node3D

var health = 5
var speed = 15
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

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group('bullet'):
		self.health -= area.get_parent().damage
		area.get_parent().queue_free()
		if self.health <= 0:
			queue_free()
	pass # Replace with function body.
