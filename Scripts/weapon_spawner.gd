extends Node3D

var pickup = preload("res://Scenes/Weapon_Pickup.tscn")

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
func _process(delta: float) -> void:
	pass

func create_new():
	if num_pickups < 3:
		num_pickups+=1
		var new_pickup = pickup.instantiate()
		var new_position : Vector3 = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)).normalized() * 15
		add_child(new_pickup)
		
		new_pickup.position = new_position
	spawn_timer.start(10)
