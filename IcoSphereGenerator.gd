extends MeshInstance3D

var scaler = 1
var dist_from_center = 1

var golden_ratio : float = (1 + sqrt(5))/2
var phi_norm_lower: float
var phi_norm_upper: float

var verts = PackedVector3Array()
var uvs = PackedVector2Array()
var normals = PackedVector3Array()
var indices = PackedInt32Array()

func _ready():
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	phi_norm_lower = sqrt(1/(1 + golden_ratio * golden_ratio))
	phi_norm_upper = phi_norm_lower * golden_ratio
	
	
	var icosahedron : Array = generate_icosahedron()
	
	fracturise(icosahedron)
	
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	ResourceSaver.save(mesh, "res://sphere.tres", ResourceSaver.FLAG_COMPRESS)
	pass

func generate_icosahedron():
	var icosahedron : Array = []
	icosahedron.append(Vector3(0,1,0))
	var a = - (phi_norm_lower*phi_norm_lower - 2)/2
	var b = sqrt(1 - a * a)
	
	for i in range(5):
		icosahedron.append(Vector3(cos(i * TAU/5)*a,b,sin(i * TAU/5)*a))
	
	for i in range(5):
		icosahedron.append(Vector3(cos(i * TAU/5 + TAU/10)*a,-b,sin(i * TAU/5 + TAU/10)*a))
		
	icosahedron.append(Vector3(0,-1,0))
	
	return icosahedron

func fracturise(icosahedron):
	verts.append(icosahedron[0])
	
	for i in range(scaler):
		for j in range(i * 5):
			var vert =  (i + 1) * icosahedron[floor(j/(i + 1))] / scaler
			verts.append(icosahedron )
	

func generate_triangles():
	
	for i in range(5):
		indices.append(0)
		indices.append(i % 5 + 1)
		indices.append((i + 1) % 5 + 1)
	
	for i in range(5):
		indices.append(11)
		indices.append(11 - (i % 5 + 1))
		indices.append(11 - ((i + 1) % 5 + 1))

	for i in range(5):
		indices.append(i + 1)
		indices.append(11 - i - 1)
		indices.append(i + 5)
		
