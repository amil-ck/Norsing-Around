extends CanvasItem

var score = 0
var score_scene_type = "menu"

var element = "Fire"

var health = 150

func _process(delta):
	pass
	
func get_input_direction():
	return get_global_mouse_position()
