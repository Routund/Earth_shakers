extends Control

var server_name = "TEST"
var ip = "127.0.0.1"
var player_count = 0

signal button_up(id : String)

@onready var button = $HBoxContainer/Control/CenterContainer/TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func refresh():
	$HBoxContainer/IP.text = ip
	$HBoxContainer/Name.text = server_name
	$HBoxContainer/Player_Count.text = str(player_count) + "/8"


func _on_texture_button_button_up() -> void:
	button_up.emit(ip)
	pass # Replace with function body.
