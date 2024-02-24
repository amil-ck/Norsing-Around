extends Sprite

var ARROW = load("res://Player/Arrow/Arrow.tscn")
var ICE_ARROW = load("res://Player/Arrow/Ice Arrow.tscn")

onready var Player = get_parent()
onready var BowAnim = $"Bow Anim"
onready var glob = get_node("/root/global_variables")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Player.get("CurrentWeapon") == self:
		bow_controller()

func bow_controller():
	position = (glob.get_input_direction() - Player.position).normalized() * 100
	rotation = Player.get_angle_to(glob.get_input_direction()) + PI / 2
	var current_element = Player.get("CurrentElement")
	if current_element == "Ice":
		ice_bow()
	elif current_element == "Fire":
		fire_bow()

func fire_bow():
	if Input.is_action_pressed("attack"):
		if frame == 0:
			BowAnim.play("Charge")
	elif Input.is_action_just_released("attack"):
		BowAnim.play("Reset")
		var Arrow = ARROW.instance()
		Arrow.init(global_position, glob.get_input_direction())
		get_tree().current_scene.add_child(Arrow)

func ice_bow():
	if Input.is_action_pressed("attack"):
		if frame == 0:
			BowAnim.play("Ice Charge")
			
	elif Input.is_action_just_released("attack"):
		BowAnim.play("Reset")
		var Arrow = ICE_ARROW.instance()
		Arrow.init(global_position, glob.get_input_direction() - Player.position)
		get_tree().current_scene.add_child(Arrow)

func switch_into():
	show()

func switch_out():
	hide()

