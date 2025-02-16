extends Node3D

var ufo = preload("res://Scenes/ufo.tscn")
var difficulty = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn():
	var rng = RandomNumberGenerator.new()
	var add_ufo = ufo.instantiate()
	var xv = rng.randf_range(-1,1)
	var yv = rng.randf_range(-1,1)
	var zv = rng.randf_range(-1,1)
	var selected_vect = Vector3(xv,yv,zv)
	add_ufo.position = selected_vect.normalized() * 4
	add_child(add_ufo)
	print('sigma skibidoink')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	print('hi')
	spawn()
	
	$Spawn_Timer.start()
