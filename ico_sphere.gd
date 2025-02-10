extends Node3D
@onready var mesh_instance : MeshInstance3D = get_node("Icosphere")
var mdt : MeshDataTool = MeshDataTool.new()
var k = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mdt.create_from_surface(mesh_instance.mesh,0)
	var verts = []
	for i in range(mdt.get_vertex_count()):
		var vert = mdt.get_vertex(i)
		verts.append([vert,0])
		for j in range(i-1):
			if vert == verts[j][0]:
				verts[j][1]+=1
				print(verts[j][1])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	k+=1
	pass
