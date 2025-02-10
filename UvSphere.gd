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

	# Vertex indices.
	var thisrow = 0
	var prevrow = 0
	var point = 0

	# Loop over rings.
	for i in range(rings + 1):
		var v = float(i) / rings
		var w = sin(PI * v)
		var y = cos(PI * v)

		# Loop over segments in ring.
		for j in range(radial_segments + 1):
			var u = float(j) / radial_segments
			var x = sin(u * PI * 2.0)
			var z = cos(u * PI * 2.0)
			var vert = Vector3(x * radius * w, y * radius, z * radius * w)
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2(u, v))
			point += 1

			# Create triangles in ring using indices.
			if i > 0 and j > 0:
				indices.append(prevrow + j - 1)
				indices.append(prevrow + j)
				indices.append(thisrow + j - 1)

				indices.append(prevrow + j)
				indices.append(thisrow + j)
				indices.append(thisrow + j - 1)

		prevrow = thisrow
		thisrow = point
	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

func _process(delta : float) -> void:
	k+=delta  
	if Input.is_action_just_pressed("jump"):
		impact_points.append([Vector3(randf()- 0.5,randf() - 0.5,randf()-0.5).normalized(),k])
		if len(impact_points)==7:
			impact_points.pop_at(0)
	
	recalculate_positions()
	
	surface_array[Mesh.ARRAY_VERTEX] = verts
	
	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	if Input.is_action_pressed("left"):
		rotation.y -= 0.02
	elif Input.is_action_pressed("right"):
		rotation.y += 0.02

func add_impact(impact_site : Vector3):
	impact_site = impact_site.normalized()
	impact_points.append(impact_site)
	var impact_image = Image.create_empty(impact_points.size(),1,false,Image.FORMAT_RGBA8);
	for i in range(len(impact_points)):
		impact_image.set_pixel(i,0,Color8(impact_site.x,impact_site.y,impact_site.z,k))

func recalculate_positions():
	if len(impact_points) != 0:
		for i in range(len(verts)):
			var vec_normal : Vector3 = verts[i].normalized()
			var additive : float = 0
			
			for impact_point in impact_points:
				# Acos gets angle between vertice and impact, sin calculates a wave for the vertice to follow, and where it is given the angle
				var angle = acos(vec_normal.dot(impact_point[0]))
				var x = abs(angle -  k + impact_point[1])
				additive -= 0.1 * pow(e,-dampening * x) * (cos(frequency * x + phase_shift) + sin(frequency*x + phase_shift))
			
			verts[i] = vec_normal * (radius + additive)
