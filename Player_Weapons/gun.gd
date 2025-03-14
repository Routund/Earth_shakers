extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$bullet_spawn.scrolling:
		if Global.client_gun == 1:
			$Snubnose.visible = true
			$grenadelauncher.visible = false
			$THEBOSS2.visible = false
		if Global.client_gun == 2:
			$Snubnose.visible = false
			$grenadelauncher.visible = true
			$THEBOSS2.visible = false
		elif Global.client_gun == 0 or Global.client_gun == 3:
			$Snubnose.visible = false
			$grenadelauncher.visible = false
			$THEBOSS2.visible = true
