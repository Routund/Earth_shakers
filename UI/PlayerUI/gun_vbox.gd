extends VBoxContainer

var active = -1
@onready var guns = [get_node("Rifle"),get_node("Shotgun"),get_node("Grenade_Launcher"),get_node("Sniper")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guns[0].visible = false
	guns[1].visible = false
	guns[2].visible = false
	guns[3].visible = false
	pass # Replace with function body.

func switch_to(new):
	guns[new].visible = true
	if active != -1:
		guns[active].modulate.a = 0.5
	guns[new].modulate.a = 1
	active = new

func remove(gun):
	guns[gun].visible = false
	active = -1
