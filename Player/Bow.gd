extends Sprite

var ARROW = load("res://Player/Arrow/Arrow.tscn")
var ICE_ARROW = load("res://Player/Arrow/Ice Arrow.tscn")
var LIGHTNING_ARROW = load("res://Player/Arrow/Lightning Arrow.tscn")

onready var Player = get_parent()
onready var BowAnim = $"Bow Anim"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Player.get("CurrentWeapon") == "Bow":
		bow_controller()

func bow_controller():
	position = (get_global_mouse_position() - Player.position).normalized() * 100
	rotation = Player.get_angle_to(get_global_mouse_position()) + PI / 2
	var current_element = Player.get("CurrentElement")
	if current_element == "Ice":
		ice_bow()
	elif current_element == "Fire":
		fire_bow()
	elif current_element == "Lightning":
		lightning_bow()

func fire_bow():
	if Input.is_action_pressed("attack"):
		if frame == 0:
			BowAnim.play("Charge")
	elif Input.is_action_just_released("attack"):
		BowAnim.play("Reset")
		var Arrow = ARROW.instance()
		Arrow.set("start_point", global_position)
		Arrow.set("end_point", get_global_mouse_position())
		Arrow.set("element", "Fire")
		get_tree().current_scene.add_child(Arrow)

func ice_bow():
	if Input.is_action_pressed("attack"):
		if frame == 0:
			BowAnim.play("Ice Charge")
	elif Input.is_action_just_released("attack"):
		BowAnim.play("Reset")
		var Arrow = ICE_ARROW.instance()
		Arrow.set("start_point", global_position)
		Arrow.set("end_point", get_global_mouse_position())
		Arrow.set("element", "Ice")
		get_tree().current_scene.add_child(Arrow)

func lightning_bow():
	if Input.is_action_pressed("attack"):
		BowAnim.play("Reset")
		var Arrow = LIGHTNING_ARROW.instance()
		Arrow.set("start_point", global_position)
		Arrow.set("end_point", get_global_mouse_position())
		get_tree().current_scene.add_child(Arrow)

func SwitchInto():
	show()

func SwitchOut():
	hide()

