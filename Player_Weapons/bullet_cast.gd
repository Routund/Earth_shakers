extends RayCast3D

var damage : int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_colliding():
		print("hit")
		var collider = get_collider()
		var parent = collider.get_parent()
		if collider.is_in_group("enemy"):
			parent.damage(damage)
			enabled = false
		elif collider.is_in_group("Player"):
			parent.damage.rpc_id(int(str(parent.name)),damage)
			enabled = false
