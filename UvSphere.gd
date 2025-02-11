extends MeshInstance3D

var rings = 75
var radial_segments = 75
var radius = 1.6

var k : float = 0

const e : float = 2.718281
const dampening : float = 1.8
const phase_shift : float = PI/4
const frequency = 15

var surface_array = []

# Vector2 describing where the impact was
var impact_points = []

var verts = PackedVector3Array()
var uvs = PackedVector2Array()
var normals = PackedVector3Array()
var indices = PackedInt32Array()

func _ready():
	randomize()
	surface_array.resize(Mesh.ARRAY_MAX)

func add_impact(impact_site : Vector3):
	impact_site = impact_site.normalized()
	impact_points.append([impact_site,k])
	var impact_image = Image.create_empty(impact_points.size(),1,false,Image.FORMAT_RGBAF)
	for i in range(len(impact_points)):
		impact_image.set_pixel(i,0,Color(impact_points[i][0].x/2 + 0.5,impact_points[i][0].y/2 + 0.5,impact_points[i][0].z/2 + 0.5,impact_points[i][1]/1000))
	material_override.set("shader_parameter/impact_data",ImageTexture.create_from_image(impact_image))
	material_override.set("shader_parameter/num_impacts",len(impact_points))
	impact_image.save_png("res://impact_img.png")

func _process(delta : float) -> void:
	k+=delta  
	if Input.is_action_just_pressed("jump"):
		add_impact(Vector3(randf()- 0.5,randf() - 0.5,randf()-0.5).normalized())
		if len(impact_points)==15:
			impact_points.pop_at(0)
	
	if Input.is_action_pressed("left"):
		rotation.y -= 0.02
	elif Input.is_action_pressed("right"):
		rotation.y += 0.02

#func recalculate_positions():
	#pass
	#if len(impact_points) != 0:
		#for i in range(len(verts)):
			#var vec_normal : Vector3 = verts[i].normalized()
			#var additive : float = 0
			#
			#for impact_point in impact_points:
				## Acos gets angle between vertice and impact, sin calculates a wave for the vertice to follow, and where it is given the angle
				#var angle = acos(vec_normal.dot(impact_point[0]))
				#var x = abs(angle -  k + impact_point[1])
				#additive -= 0.1 * pow(e,-dampening * x) * (cos(frequency * x + phase_shift) + sin(frequency*x + phase_shift))
			#
			#verts[i] = vec_normal * (radius + additive)
