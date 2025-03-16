extends Node3D

var old_transform : Transform3D
var moving : bool = true
var k = 0

var gun = 0

var model_child

var guns = [
	"res://Player_Weapons/Pistol/snubnose2.tscn",
	"res://Player_Weapons/Pistol/snubnose2.tscn",
	"res://Player_Weapons/Grenade_Launcher/grenadelauncher.tscn",
	"res://Player_Weapons/Pistol/snubnose2.tscn"
]

var sizes = [ 0.25, 0.25, 0.4, 0.25]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(gun)
	var model = load(guns[gun]).instantiate()
	model.scale = Vector3(sizes[gun],sizes[gun],sizes[gun])
	model.position.y += 1.0
	add_child(model)
	model_child = get_child(2)
	model_child.position.y += 0.2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if moving:
		look_at(Vector3(0,0,0))
		rotate_object_local(Vector3(1,0,0).normalized(), PI/2)
		moving = false
	
	position = Gravity.check_ground(position)[0]
	position = position.normalized() * (position.length() - 0.5)
	
	model_child.rotation.y += delta * 5
	pass

func _on_static_body_3d_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("Player"):
		delete_pickup.rpc(int(str(area.get_parent().name)),area)
		
	pass # Replace with function body.

@rpc("any_peer","call_local")
func delete_pickup(player_id,area):
	if multiplayer.get_unique_id() == player_id or !Global.networking:
		get_parent().num_pickups -= 1
		area.get_parent().gun_manager.change_ammo(1,gun)
		
	queue_free()
