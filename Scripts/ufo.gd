extends Node3D

var moving = true
var health = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moving:
		look_at(Vector3(0,0,0))
		rotate_object_local(Vector3(1,0,0).normalized(), PI/2)
		moving = false


func _on_despawn_timeout() -> void:
	queue_free()


func _on_area_3_dufo_area_entered(area: Area3D) -> void:
	if area.is_in_group('bullet'):
		self.health -= area.get_parent().damage
		area.get_parent().queue_free()
		if self.health <= 0:
			queue_free()
