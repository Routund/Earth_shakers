extends Node3D

var scrolling = false
var cooldown = false
var scrolltick = 0

var bullet = load("res://Player_Weapons/Pistol/bullet.tscn")
var rocket = load("res://Player_Weapons/Grenade_Launcher/rpg_bullet.tscn")
var instance

var equipped = true
signal shot(power : float)
var shooting = false
@onready var player = $"../../.."

var gun_ui
var ammo = [0,0,0,0]
var clips = [0,0,0,0]
var clip_values = [1,1,1,1]

@onready var guns = [
	get_node("Shotgun/Snubnose"),
	get_node("Shotgun/Snubnose"),
	get_node("RPG/Grenadelauncher"),
	get_node("Shotgun/Snubnose"),
	]

var player_client = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_client:
		gun_ui = player.get_node("CanvasLayer").get_node("VBoxContainer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !player_client or shooting:
		pass
	else:
		if Input.is_action_just_pressed('reload'):
			ammo[Global.client_gun] = 0
			$reload.start(2)
		if Input.is_action_just_pressed('scroll') and !scrolling:
			scrolling = true
			scroll_gun(-1)
			$scroll.start(0.02)
		if Input.is_action_just_pressed('scrolld') and !scrolling:
			scrolling = true
			scroll_gun(1)
			$scrolld.start(0.02)

		if !scrolling:
			if Input.is_action_pressed("shoot") and !cooldown and ammo[Global.client_gun] > 0:
				if Global.client_gun == 0:
					shoot_rifle.rpc()
					$shoot_cooldown.start(0.36)
				elif Global.client_gun == 1:
					shoot_shotgun.rpc(multiplayer.get_unique_id())
					shot.emit(0.05)
					$shoot_cooldown.start(0.75)
				elif Global.client_gun == 2: 
					shoot_rpg.rpc(multiplayer.get_unique_id())
					shot.emit(0.05)
					$shoot_cooldown.start(1.1)
				elif Global.client_gun == 3: #this is a sniper change the damage values for this
					shot.emit(0.7)
					shoot_sniper.rpc()
					$shoot_cooldown.start(2)
				guns[Global.client_gun].get_node("AnimationPlayer").play("shoot")
				change_ammo(-1,Global.client_gun)
				cooldown = true

func scroll_gun(change):
	var new = Global.client_gun 
	new += change
	while Global.client_gun != new:
		
		if new < 0:
			new = 3
		elif new > 3:
			new = 0
		
		if ammo[new] > 0 or clips[new] > 0:
			break
		else:
			new += change
	
	if Global.client_gun != new:
		change_gun(new)

func change_gun(new):
	guns[Global.client_gun].visible = false
	Global.client_gun = new
	guns[new].visible = true
	guns[new].get_node("AnimationPlayer").play("equip")
	gun_ui.switch_to(new)

func change_ammo(change,gun):
	if change == 1:
		if ammo[gun] == 0 and clips[gun] == 0:
			ammo[gun] += clip_values[gun]
			change_gun(gun)
		else:
			clips[gun] += 1
	else:
		ammo[gun] -= 1
		if ammo[gun] == 0 and clips[gun] == 0:
			guns[Global.client_gun].visible = false
			scroll_gun(-1)
			gun_ui.remove(gun)


func _on_scroll_timeout() -> void:
	scrolling = false

func _on_shoot_cooldown_timeout() -> void:
	cooldown = false

@rpc("any_peer","call_local")
func shoot_rpg(parent):
	instance = rocket.instantiate()
	instance.transform = global_transform
	instance.position = $"shotgun spawn".global_position
	instance.gravity_velocity = player.velocity
	instance.name = "bullet %s %s" % [MultiplayerManager.bullet_id, parent]
	MultiplayerManager.bullet_id +=1
	player.get_parent().add_child(instance)
	if ammo[Global.client_gun] <= 0:
		$reload.start(2)

@rpc("any_peer","call_local")
func shoot_rifle():
	shooting = true
	$Bullet_cast.damage = 5
	$Bullet_cast.enabled = true
	await get_tree().create_timer(0.5).timeout
	$Bullet_cast.enabled = false
	shooting = false
	if ammo[Global.client_gun] <= 0:
		$reload.start(2)
		

@rpc("any_peer","call_local")
func shoot_shotgun(parent):
	for i in range(17):
		instance = bullet.instantiate()
		instance.transform = global_transform
		instance.rotation += Vector3(deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)))
		instance.position = $"shotgun spawn".global_position
		instance.name = "bullet %s %s" % [MultiplayerManager.bullet_id,parent]
		MultiplayerManager.bullet_id +=1
		player.get_parent().add_child(instance)
	if ammo[Global.client_gun] <= 0:
		$reload.start(2)

@rpc("any_peer","call_local")
func shoot_sniper():
	shooting = true
	$Bullet_cast.damage = 15
	$Bullet_cast.enabled = true
	await get_tree().create_timer(0.5).timeout
	$Bullet_cast.enabled = false
	shooting = false


func _on_reload_timeout() -> void:
	if clips[Global.client_gun] > 0:
		ammo[Global.client_gun] = clip_values[Global.client_gun]
		clips[Global.client_gun] -= 1


func _on_scrolld_timeout() -> void:
	scrolling = false
	pass # Replace with function body.
