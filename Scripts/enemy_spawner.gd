extends Node3D

var ufo = preload("res://Scenes/ufo.tscn")
var ship = preload("res://Scenes/ship.tscn")
var difficulty = 100
var radius : float = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_ufo():
	var rng = RandomNumberGenerator.new()
	var add_ufo = ufo.instantiate()
	var xv = rng.randf_range(-1,1)
	var yv = rng.randf_range(-1,1)
	var zv = rng.randf_range(-1,1)
	var selected_vect = Vector3(xv,yv,zv)
	add_ufo.position = selected_vect.normalized() * radius * 1.20 #1.25 is how far off the planet it is
	add_child(add_ufo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_ship():
	var rng = RandomNumberGenerator.new()
	var add_ship = ship.instantiate()
	var xv = rng.randf_range(-1,1)
	var yv = rng.randf_range(-1,1)
	var zv = rng.randf_range(-1,1)
	var selected_vect = Vector3(xv,yv,zv)
	add_ship.position = selected_vect.normalized() * radius * 1.4 #1.15 is how far off the planet it is
	add_child(add_ship)

func _on_timer_timeout() -> void:
	spawn_ufo()
	spawn_ship()
	$Spawn_Timer.start()
