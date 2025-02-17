extends CharacterBody3D


const SPEED = 5.0
const SENS = 0.005

var bullet = load("res://Scenes/bullet.tscn")
var instance 
var bullet_rotation = 0

var gravitational_velocity : Vector3 = Vector3.ZERO
var jump_velocity : Vector3 = Vector3.ZERO
var perpendicular_movement : Vector3 = Vector3.ZERO
var direction : Vector3 = Vector3.ZERO
var position_normalized : Vector3
var camera_yaw :float = 0
@onready var head = $head
@onready var camera = $head/Camera3D

var grounded : bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera_yaw = event.relative.x * SENS
		camera.rotate_x(-event.relative.y * SENS)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		for i in range(5):
			bullet_rotation += 1000
			instance = bullet.instantiate()
			instance.position = $head/Camera3D/gun/bullet_spawn.global_position 
			instance.transform.basis = $head/Camera3D/gun/bullet_spawn.global_transform.basis * bullet_rotation
			get_parent().add_child(instance)
		bullet_rotation = 0
		
	position_normalized = position.normalized()
	
	# If player isn't grounded, increase the amount of velocity due to gravity
	if !grounded:
		var accel = Gravity.gravitate(position)
		gravitational_velocity += -accel[0] * delta * 1
		var ground_result = Gravity.check_ground(position + velocity * delta)
		if ground_result[1]:
			# Resets velocity due to gravity and jumping, and sets player position to be on top of planet
			gravitational_velocity = Vector3.ZERO
			jump_velocity = Vector3(0,0,0)
			position = ground_result[0]
			grounded = true
			velocity = Vector3.ZERO
	else:
		# If player grounded, reset their position to be on top of the planet
		position = Gravity.check_ground(position + (gravitational_velocity + jump_velocity)*delta)[0]

	rotate_player()
	
	# Let player escape mouse
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction or camera_yaw !=0 :
		perpendicular_movement = (direction.x * transform.basis.x + direction.z * transform.basis.z) * SPEED
		camera_yaw = 0
	else:
		perpendicular_movement.x = move_toward(perpendicular_movement.x, 0, SPEED)
		perpendicular_movement.z = move_toward(perpendicular_movement.z, 0, SPEED)
		perpendicular_movement.y = move_toward(perpendicular_movement.y, 0, SPEED)
	# Add to jump velocity
	if Input.is_action_just_pressed("jump") and grounded:
		jump_velocity += position.normalized() * 5
		grounded = false
	
	
	# Set velocity based off how much gravity, player control, and jump force, would cause it to
	velocity = perpendicular_movement + gravitational_velocity + jump_velocity
	move_and_slide()
		
	
func rotate_player():
	
	print(position)
	
	# Change_player_position
	var relative_up : Vector3 = position_normalized
	var player_forward : Vector3 = -transform.basis.z
	var side_axis : Vector3 = relative_up.cross(player_forward)
	var new_forward : Vector3 = relative_up.cross(side_axis)
	transform = transform.looking_at(-new_forward,relative_up)
	#print(angle_between)

	
	transform = Transform3D(transform.basis.x,transform.basis.z,-transform.basis.y,position)
	
	transform = transform.rotated(transform.basis.y, -camera_yaw)
	
	camera_yaw = 0
	
	transform.orthonormalized()
	
