extends Control

var max_health = 150
var hearts = 3
var heart_list = []

var health_loss = 0
onready var glob = $"/root/global_variables"

func _ready():
	for i in range(hearts):
		heart_list.append(get_node(str(i)))

func _process(delta):
	if health_loss > 0:
		glob.health -= 10 * delta
		health_loss -= 10 * delta
		print(glob.health)
		
		if glob.health <= 0:
			$"/root/global_variables".score_scene_type = "game"
			get_tree().change_scene("res://High Scores.tscn")
		
		heart_controller()

func heart_controller():
	var cur_heart = 0
	var pieces_missing = 23 - ceil((glob.health / max_health) * hearts * 8)
	
	for i in range(floor(pieces_missing / 8)):
		get_node(str(i)).frame = 7
		cur_heart += 1
	
	if cur_heart < hearts:
		get_node(str(cur_heart)).frame = fmod(pieces_missing, 8)

func _input(event):
	if event.is_action_pressed("special"):
		stop_loss()

func health_update(change):
	health_loss = -change

func stop_loss():
	health_loss = 0
