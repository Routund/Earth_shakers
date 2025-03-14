extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var rand_h = randf()
	var rand_s = randf_range(0.2,0.7)
	var rand_v = min(1.0,randf_range(0.6 + rand_s,1.0))
	var new_color = Color.from_hsv(rand_h,rand_s,rand_v)
	$Skeleton3D/Cube.mesh.surface_get_material(0).albedo_color = new_color
	$Skeleton3D/Cube_003.mesh.surface_get_material(0).albedo_color = new_color
	$Skeleton3D/Cube_004.mesh.surface_get_material(0).albedo_color = new_color

	$AnimationPlayer.play("mixamo_com")
	Global.num_slims += 1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform = Gravity.rotate_object(position, transform)
	pass

func _exit_tree() -> void:
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.play("mixamo_com")
