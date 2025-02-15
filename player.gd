extends CharacterBody3D


const SPEED = 5.0
const SENS = 0.005

var gravitational_velocity : Vector3 = Vector3(0,0,0)
var jump_velocity : Vector3 = Vector3(0,0,0)

@onready var head = $head
@onready var camera = $head/Camera3D

var grounded : bool = false
var perpendicular_movement : Vector3 = Vector3(0,0,0)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#rotate_y(-event.relative.x * SENS)
		#camera.rotate_x(-event.relative.y * SENS)
		#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(85))
		#

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !grounded:
		var accel = Gravity.gravitate(position)
		gravitational_velocity += -accel[0] * delta * 1
		var ground_result = Gravity.check_ground(position + velocity * delta)
		if ground_result[1]:
			gravitational_velocity = Vector3.ZERO
			position = ground_result[0]
			grounded = true
			jump_velocity = Vector3(0,0,0)
			velocity = Vector3.ZERO
		$RayCast3D.target_position = gravitational_velocity *delta
	else:
		position = Gravity.check_ground(position + velocity*delta)[0]
		print(position)
		$RayCast3D.target_position = gravitational_velocity * delta

	# Handle jump.

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		perpendicular_movement.x = direction.x * SPEED
		perpendicular_movement.z = direction.z * SPEED
	else:
		perpendicular_movement.x = move_toward(perpendicular_movement.x, 0, SPEED)
		perpendicular_movement.z = move_toward(perpendicular_movement.z, 0, SPEED)
	
	if Input.is_action_just_pressed("jump") and grounded:
		jump_velocity += position.normalized() * 5
		print("Jumped")
		grounded = false
	move_and_slide()
	
	velocity = perpendicular_movement + gravitational_velocity + jump_velocity
	
