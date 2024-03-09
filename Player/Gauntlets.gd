extends Node2D

onready var player = get_parent()
var ICE_WALL = load("res://Ice Wall.tscn")
onready var glob = get_node("/root/global_variables")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.current_weapon == self:
		gauntlet_controller()

func gauntlet_controller():
	position = (glob.get_input_direction() - player.position).normalized() * 50
	rotation = player.get_angle_to(glob.get_input_direction()) + PI/2
	
	if Input.is_action_just_pressed("attack"):
		if player.current_element == "Fire":
			$AnimationPlayer.play("Fire Attack")
		elif player.current_element == "Ice":
			$AnimationPlayer.play("Ice Attack")
		
	if Input.is_action_just_pressed("special") and player.current_element == "Ice":
		var ice_wall = ICE_WALL.instance()
		var wall_pos = player.position + (glob.get_input_direction() - player.position).normalized() * -100
		ice_wall.global_position = wall_pos
		get_tree().current_scene.add_child(ice_wall)
		ice_wall.rotation = ice_wall.get_angle_to(glob.get_input_direction()) + PI/2
		
	if Input.is_action_just_pressed("block"):
		pass
		
func switch_into():
	show()

func switch_out():
	hide()
