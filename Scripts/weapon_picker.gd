extends Node3D

var old_transform : Transform3D
var moving : bool = true
var k = 0

var gun = 0;

var guns = [
	"res://Sculptures/"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	gun = randi_range(0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if moving:
		look_at(Vector3(0,0,0))
		rotate_object_local(Vector3(1,0,0).normalized(), PI/2)
		moving = false
	
	position = Gravity.check_ground(position)[0]
	position = position.normalized() * (position.length() - 0.5)
	pass


func _on_static_body_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		queue_free()
	pass # Replace with function body.
