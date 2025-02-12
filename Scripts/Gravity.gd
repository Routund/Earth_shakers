extends Node

const e : float = 2.718281;
const dampening : float = 2.0;
const phase_shift : float = PI/4.0;
const frequency : float = 15.0;
const height : float = 0.1;
const radius : float = 1.5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gravitate(position : Vector3):
	var gravity_magnitude = 1.0
	var target_position : Vector3 = position -position.normalized() * gravity_magnitude
	target_position = check_ground(target_position)
	return target_position

func check_ground(place : Vector3) -> Vector3:
	var impact_points : Array = $Planet.impact_points
	var k : float = $Planet.k
	
	var vec_normal : Vector3 = place.normalized()
	var additive : float = 0
	
	for impact_point in impact_points:
		# Acos gets angle between vertice and impact, sin calculates a wave for the vertice to follow, and where it is given the angle
		var angle = acos(vec_normal.dot(impact_point[0]))
		var x = abs(angle -  k + impact_point[1])
		additive -= 0.1 * pow(e,-dampening * x) * (cos(frequency * x + phase_shift) + sin(frequency*x + phase_shift))
	var dist_from_center = radius + additive
	var place_dist = place.length()
	
	if dist_from_center > place_dist:
		return vec_normal * (radius + additive)
	else:
		return place
