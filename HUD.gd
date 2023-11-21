extends Control

var score = 0
onready var pointer = $Pointer
onready var icon = $element

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
		if icon.texture.load_path == "res://Player/Fire.png":
			icon.texture = load("res://Player/lightning.png")
		elif icon.texture.load_path == "res://Player/lightning.png":
			icon.texure = load("res://Player/ice.png")
		elif icon.texture.load_path == "res://Player/ice.png":
			icon.texture = load("res://Player/Fire.png")

func _score_update(change):
	score += change
	$Score.text = str(score)
