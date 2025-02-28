extends CharacterBody3D


const SPEED = 9.0
const SENS = 0.005

var gravitational_velocity : Vector3 = Vector3.ZERO
var gravity_scale : float = 1.5
var jump_velocity : Vector3 = Vector3.ZERO
var jump_scale : float = 7
var perpendicular_movement : Vector3 = Vector3.ZERO

var direction : Vector3 = Vector3.ZERO
var position_normalized : Vector3
var camera_yaw :float = 0

var ground_pounding : bool = false
signal ground_pounded(power : float)

@onready var head = $head
@onready var camera = $head/Camera3D
@onready var Planet = get_parent().get_node("Planet")

var grounded : bool = false
var ground_pound_jump_increase_timer : Timer = Timer.new()

var walk_shake_timer : Timer = Timer.new()

func _ready():
	add_child(ground_pound_jump_increase_timer)
	ground_pound_jump_increase_timer.connect("timeout",reset_ground_pound_jump)
	add_child(walk_shake_timer)
	walk_shake_timer.one_shot = true

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera_yaw = event.relative.x * SENS
		camera.rotate_x(-event.relative.y * SENS)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta: float) -> void:
	position_normalized = position.normalized()
	
	# If player isn't grounded, increase the amount of velocity due to gravity
	if !grounded:
		if Input.is_action_just_pressed("ground_pound") and position.length() > 17.5:
			ground_pounding = true
			gravity_scale = 16
			print("Pounding")
		var accel = Gravity.gravitate(position)
		gravitational_velocity += -accel[0] * delta * gravity_scale
		var ground_result = Gravity.check_ground(position + velocity * delta)
		if ground_result[1]:
			# Resets velocity due to gravity and jumping, and sets player position to be on top of planet
			gravitational_velocity = Vector3.ZERO
			jump_velocity = Vector3.ZERO
			velocity = Vector3.ZERO
			
			position = ground_result[0]
			grounded = true
			gravity_scale = 1.5
			if ground_pounding:
				Planet.add_impact(position,1)
				ground_pounding = false
				ground_pounded.emit(0.12)
				jump_scale = 10
				ground_pound_jump_increase_timer.start(0.12)
			else:
				Planet.add_impact(position,0.1)
	else:
		# If player grounded, reset their position to be on top of the planet
		position = Gravity.check_ground(position + (gravitational_velocity + jump_velocity)*delta)[0]

	transform = Gravity.rotate_object(position,transform,camera_yaw)
	camera_yaw = 0
	
	# Let player escape mouse

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	
	
	if direction:
		perpendicular_movement = (direction.x * transform.basis.x + direction.z * transform.basis.z) * SPEED
		if walk_shake_timer.time_left == 0 and grounded:
			Planet.add_impact(position,0.05)
			walk_shake_timer.start(0.03)
	else:
		perpendicular_movement.x = move_toward(perpendicular_movement.x, 0, SPEED)
		perpendicular_movement.z = move_toward(perpendicular_movement.z, 0, SPEED)
		perpendicular_movement.y = move_toward(perpendicular_movement.y, 0, SPEED)
	# Add to jump velocity
	if Input.is_action_just_pressed("jump") and grounded:
		Planet.add_impact(position,0.1)
		jump_velocity += position.normalized() * jump_scale
		grounded = false
	
	
	# Set velocity based off how much gravity, player control, and jump force, would cause it to
	velocity = perpendicular_movement + gravitational_velocity + jump_velocity
	move_and_slide()

func reset_ground_pound_jump():
	jump_scale = 7
