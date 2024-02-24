extends Control

var score = 0
onready var pointer = $Pointer
onready var icon = get_parent().get_node("Control (element)/element")
onready var score_label = get_parent().get_node("Control (score)/Score")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var middle = get_viewport().size / 2
	
	var nearest_stunned = null
	
	var player_pos = get_node("/root/Level/Player").position
	
	for body in get_tree().get_nodes_in_group("Melee Enemies"):
		if body.stunned:
			if nearest_stunned == null:
				nearest_stunned = body
			elif body.position.distance_to(player_pos) < nearest_stunned.position.distance_to(player_pos):
				nearest_stunned = body
		
		if nearest_stunned != null:
			pointer.position = middle + (nearest_stunned.position - player_pos).normalized() * 80
			pointer.rotation = player_pos.angle_to_point(nearest_stunned.position) - PI / 2

func _input(event):
	if Input.is_action_just_pressed("switch_element"):
		if $"/root/global_variables".element == "Fire":
			icon.texture = load("res://Player/Fire.png")
		elif $"/root/global_variables".element == "Ice":
			icon.texture = load("res://Player/ice.png")

func _score_update(change):
	score += change
	score_label.text = str(score)
	
	$"/root/global_variables".score = score
