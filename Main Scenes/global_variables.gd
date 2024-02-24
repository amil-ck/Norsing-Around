extends Node2D

var player

var score = 0
var score_scene_type = "menu"

var element = "Fire"

var health = 150

var control_scheme = "M&K"

func _input(event):
	if event is InputEventKey or event is InputEventMouse:
		control_scheme = "M&K"
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		control_scheme = "Controller"
	
func get_input_direction():
	if control_scheme == "M&K":
		return get_global_mouse_position()
	elif control_scheme == "Controller":
		var r_stick_dir = Vector2(Input.get_vector("r_left", "r_right", "r_up", "r_down"))
		return player.global_position + r_stick_dir * 1000
