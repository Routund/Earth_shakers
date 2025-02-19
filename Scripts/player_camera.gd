extends Camera3D

var shake : float = 0
var reset_flag = 0

var rotation_x_old = 0
var rotation_y_old = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake!=0:
		rotation.x = rotation_x_old + randf_range(-1,1) * shake
		rotation.y = rotation_y_old + randf_range(-1,1) * shake
	elif reset_flag:
		rotation.x = rotation_x_old
		rotation.y = rotation_y_old
		reset_flag = false
	pass


func _on_bullet_spawn_shot(power : float) -> void:
	shake = power
	reset_flag = true
	rotation_x_old = rotation.x
	rotation_y_old = rotation.y
	var tween = create_tween()
	tween.tween_property(self,"shake",0,0.15)
	pass # Replace with function body.
