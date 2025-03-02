extends CharacterBody3D

var time = 0.25
var damage = 1
var speed = 60
var gravity_scale = 0.025

@onready var timer = get_node("Timer")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(time)

func _process(_delta: float) -> void:
	if Gravity.check_ground(position)[1]:
		if !Global.networking:
			delete_bullet()
		elif multiplayer.is_server():
			delete_bullet.rpc()
	velocity = speed * -transform.basis.z
	move_and_slide()

func _on_timer_timeout():
	if !Global.networking:
		delete_bullet()
	elif multiplayer.is_server():
		delete_bullet.rpc()

@rpc("any_peer","call_local")
func delete_bullet():
	queue_free()


#func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body.is_in_group("Player"):
		#print("Multiplayer %s Name %s" % [multiplayer.get_unique_id(), int(str(body.name))])
		#if !Global.networking:
			#body.damage(damage)
			#queue_free()
		#else:
			#body.damage.rpc_id(int(str(body.name)),damage)
			#delete_bullet.rpc()
