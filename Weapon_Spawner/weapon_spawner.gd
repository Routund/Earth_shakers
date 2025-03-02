extends Node3D

var pickup = preload("res://Weapon_Spawner/Weapon_Pickup.tscn")

var spawn_timer = Timer.new()

var num_pickups = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	add_child(spawn_timer)
	spawn_timer.start(1)
	spawn_timer.connect("timeout",create_new)
	spawn_timer.autostart = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func create_new():
	if !Global.networking or multiplayer.get_unique_id() == 1:
		if num_pickups < 5:
			num_pickups+=1
			var new_position : Vector3 = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)).normalized() * 15
			var gun = randi_range(0,2)
			place_new.rpc(new_position,gun)
		spawn_timer.start(6.3)

@rpc("call_local","any_peer")
func place_new(pos,gun_id):
	var new_pickup = pickup.instantiate()
	add_child(new_pickup)
	new_pickup.position = pos
	new_pickup.gun = gun_id
	
