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
		rotation_x_old = 0
		rotation_y_old = 0
		reset_flag = false
	transform.orthonormalized()
	pass


func _on_bullet_spawn_shot(power : float) -> void:
	
	# Documented that multiple shots unlock camera rotation
	# Perhaps add a cooldown timer to stop such things?
	
	shake = power
	reset_flag = true
	# Set what old rotation is to beafter shake is finished
	rotation_x_old = rotation.x
	rotation_y_old = rotation.y
	var tween = create_tween()
	tween.tween_property(self,"shake",0,0.15)
	pass # Replace with function body.


func _on_player_ground_pounded(power : float) -> void:
	shake = power
	reset_flag = true
	# Set what old rotation is to beafter shake is finished
	rotation_x_old = rotation.x
	rotation_y_old = rotation.y
	var tween = create_tween()
	tween.tween_property(self,"shake",0,0.15)
	pass # Replace with function body.
	pass # Replace with function body.
