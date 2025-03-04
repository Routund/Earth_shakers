extends CharacterBody3D

var time = 2
var damage = 10
var speed = 20
var gravity_scale = 0.07
var falling = true

@onready var timer = get_node("Timer")

var gravity_velocity : Vector3 = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(time)

func _process(_delta: float) -> void:
	if Gravity.check_ground(position)[1]:
		damage = 5
		$explosion/CollisionShape3D.disabled = false
		if falling:
			falling = false
			get_parent().get_node("Planet").initiate_impact(position,0.5)
		await get_tree().create_timer(1).timeout
		if !Global.networking:
			delete_bullet()
		elif multiplayer.is_server():
			delete_bullet.rpc()

	gravity_velocity += -Gravity.gravitate(position)[0] * gravity_scale
	velocity = speed * -transform.basis.z + gravity_velocity
	move_and_slide()

func _on_timer_timeout():
	queue_free()

@rpc("any_peer","call_local")
func delete_bullet():
	$explosion/CollisionShape3D.disabled = false
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Multiplayer %s Name %s" % [multiplayer.get_unique_id(), int(str(body.name))])
		if !Global.networking:
			body.damage(damage)
			queue_free()
		else:
			body.damage.rpc_id(int(str(body.name)),damage)
			delete_bullet.rpc()
#
#
func _on_explosion_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Multiplayer %s Name %s" % [multiplayer.get_unique_id(), int(str(body.name))])
		if !Global.networking:
			body.damage(damage)
			body.damage(damage)
			queue_free()
		else:
			body.damage.rpc_id(int(str(body.name)),damage)
			body.launch()
			delete_bullet.rpc()
