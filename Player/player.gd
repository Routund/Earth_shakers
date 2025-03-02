extends CharacterBody3D


const SPEED = 9.0
const SENS = 0.0035

var gravitational_velocity : Vector3 = Vector3.ZERO
var gravity_scale : float = 1.5
var jump_velocity : Vector3 = Vector3.ZERO
var jump_scale : float = 7
var perpendicular_movement : Vector3 = Vector3.ZERO
var grounded : bool = false

var direction : Vector3 = Vector3.ZERO
var position_normalized : Vector3
var camera_yaw :float = 0

var ground_pounding : bool = false
signal ground_pounded(power : float)

@onready var head = $head
@onready var camera = $head/Camera3D
@onready var Planet = get_parent().get_node("Planet")

var ground_pound_jump_increase_timer : Timer = Timer.new()
var walk_shake_timer : Timer = Timer.new()
var wave_invincibility_timer : Timer = Timer.new()

var player_client = true

func _ready():
	# Adding timers
	add_child(ground_pound_jump_increase_timer)
	ground_pound_jump_increase_timer.connect("timeout",reset_ground_pound_jump)
	add_child(walk_shake_timer)
	walk_shake_timer.one_shot = true
	add_child(wave_invincibility_timer)
	wave_invincibility_timer.one_shot = true
	
	# Networking Code - Sets the player as the clients player if id matches
	if Global.networking:
		var new_id = str(name).to_int()
		$MultiplayerSynchronizer.set_multiplayer_authority(new_id)
		if new_id == multiplayer.get_unique_id():
			var ui = load("res://UI/player_ui.tscn").instantiate()
			add_child(ui)
			camera.current = true
		else:
			player_client = false
			$head/Camera3D/gun/bullet_spawn.player_client = false

func _unhandled_input(event):
	if player_client:
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			camera_yaw = event.relative.x * SENS
			camera.rotate_x(-event.relative.y * SENS)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta: float) -> void:
	if player_client:
		position_normalized = position.normalized()
		
		# If player isn't grounded, increase the amount of velocity due to gravity
		if !grounded:
			if Input.is_action_just_pressed("ground_pound") and position.length() > 17.5:
				ground_pounding = true
				gravity_scale = 16
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
					Planet.initiate_impact(position,1)
					ground_pounding = false
					ground_pounded.emit(0.12)
					jump_scale = 10
					ground_pound_jump_increase_timer.start(0.12)
					wave_invincibility_timer.start(0.9)
				else:
					Planet.initiate_impact(position,0.1)
		else:
			# If player grounded, reset their position to be on top of the planet
			var new_position = Gravity.check_ground(position + (gravitational_velocity + jump_velocity)*delta)[0]
			
			if (new_position.length() > 15.4 and wave_invincibility_timer.time_left == 0):
				damage(5)
				print("Shocked")
				wave_invincibility_timer.start(0.5)
			position = new_position

		transform = Gravity.rotate_object(position,transform,camera_yaw)
		camera_yaw = 0
		
		# Let player escape mouse

		# Get the input direction and handle the movement/deceleration.
		var input_dir := Input.get_vector("left", "right", "up", "down")
		direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
		if direction:
			perpendicular_movement = (direction.x * transform.basis.x + direction.z * transform.basis.z) * SPEED
			if walk_shake_timer.time_left == 0 and grounded:
				Planet.initiate_impact(position,0.05)
				walk_shake_timer.start(0.03)
		else:
			perpendicular_movement.x = move_toward(perpendicular_movement.x, 0, SPEED)
			perpendicular_movement.z = move_toward(perpendicular_movement.z, 0, SPEED)
			perpendicular_movement.y = move_toward(perpendicular_movement.y, 0, SPEED)
		# Add to jump velocity
		if Input.is_action_just_pressed("jump") and grounded:
			Planet.initiate_impact(position,0.1)
			jump_velocity += position.normalized() * jump_scale
			grounded = false
		
		
		# Set velocity based off how much gravity, player control, and jump force, would cause it to
		velocity = perpendicular_movement + gravitational_velocity + jump_velocity
		move_and_slide()

func reset_ground_pound_jump():
	jump_scale = 7

@rpc("any_peer","call_local")
func damage(value):
	if player_client:
		$CanvasLayer/Health_Bar.change_health(value)


func _on_area_3d_area_entered(area: Area3D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("enemy_bullet"):
		damage(parent.damage)
	elif area.is_in_group("bullet"):
		if (str(parent.name).split(" ")[2]) == str(name) or !Global.networking:
			if parent.time - parent.timer.time_left < 0.1:
				return
		damage.rpc_id(int(str(name)),parent.damage)
		parent.delete_bullet.rpc()
			
	pass # Replace with function body.
