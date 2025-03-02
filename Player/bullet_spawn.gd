extends Node3D

var cooldown = false
var scrolltick = 0
var bullet = load("res://Player_Weapons/bullet.tscn")
var rocket = load('res://Player_Weapons/rpg_bullet.tscn')
var instance
var equipped = true
signal shot(power : float)
@onready var player = $"../../../.."

var player_client = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !player_client:
		pass
	else:
		if Input.is_action_just_pressed('scroll'):
			scrolltick += 1
			Global.client_gun += 1
			$scroll.start(0.1)
		if Input.is_action_just_pressed('scrolld'):
			scrolltick += 1
			Global.client_gun -= 1
			$scrolld.start(0.1)
			
		if Input.is_action_pressed("shoot") and not cooldown:
			cooldown = true
			if Global.client_gun == 0:
				shoot_pistol.rpc()
				$shoot_cooldown.start(0.25)
			elif Global.client_gun == 1:
				shoot_shotgun.rpc(multiplayer.get_unique_id())
				shot.emit(0.05)
				$shoot_cooldown.start(0.75)
			elif Global.client_gun == 2: 
				shoot_rpg.rpc(multiplayer.get_unique_id())
				shot.emit(0.05)
				$shoot_cooldown.start(1)
			elif Global.client_gun == 3: #this is a sniper change the damage values for this
				shoot_pistol.rpc()
				$shoot_cooldown.start(2)
			


func _on_scroll_timeout() -> void:
	Global.client_gun -= (scrolltick-1)
	scrolltick = 0
	if Global.client_gun > 3:
		Global.client_gun = 0


func _on_scrolld_timeout() -> void:
	Global.client_gun += (scrolltick-1)
	scrolltick = 0
	if Global.client_gun < 0:
		Global.client_gun = 3

func _on_shoot_cooldown_timeout() -> void:
	cooldown = false

@rpc("any_peer","call_local")
func shoot_rpg(parent):
	instance = rocket.instantiate()
	instance.transform = global_transform
	instance.position = global_position
	instance.gravity_velocity = player.velocity
	instance.name = "bullet %s %s" % [MultiplayerManager.bullet_id, parent]
	MultiplayerManager.bullet_id +=1
	player.get_parent().add_child(instance)

@rpc("any_peer","call_local")
func shoot_pistol():
	$"../Bullet_cast".enabled = true
	await get_tree().create_timer(0.1).timeout
	$"../Bullet_cast".enabled = false

@rpc("any_peer","call_local")
func shoot_shotgun(parent):
	for i in range(17):
		instance = bullet.instantiate()
		instance.transform = global_transform
		instance.rotation += Vector3(deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)),deg_to_rad(randf_range(-3,3)))
		instance.position = global_position
		instance.name = "bullet %s %s" % [MultiplayerManager.bullet_id,parent]
		MultiplayerManager.bullet_id +=1
		player.get_parent().add_child(instance)
