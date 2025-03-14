extends Node3D

var ufo = preload("res://Enemies/UFO/ufo.tscn")
var ship = preload("res://Enemies/Ship/ship.tscn")
var difficulty = 100
var radius : float = 15
var spread = 0.55

@onready var player = get_parent().get_node("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

func generate_spawn():
	var base_new : Vector3 = - player.position.normalized()
	base_new.x += randf_range(-spread,spread)
	base_new.y += randf_range(-spread,spread)
	base_new.z += randf_range(-spread,spread)
	
	return(base_new)
	

func spawn_ufo():
	var add_ufo = ufo.instantiate()
	var selected_vect = generate_spawn()
	add_ufo.position = selected_vect.normalized() * radius * 1.25 #1.25 is how far off the planet it is
	add_child(add_ufo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_ship():
	var add_ship = ship.instantiate()
	var selected_vect = generate_spawn()
	add_ship.position = selected_vect.normalized() * radius * 1.4 #1.15 is how far off the planet it is
	add_child(add_ship)

func _on_timer_timeout() -> void:
	if Global.num_ufos < Global.max_ufos:
		spawn_ufo()
	if Global.num_ships < Global.max_ships:
		spawn_ship()
	$Spawn_Timer.start()
