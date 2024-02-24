extends KinematicBody2D

onready var glob = get_node("/root/global_variables")

export var speed = 400
export var dashing = false
export var dash_speed = 5000

var joystick = false

var CurrentElement = "Fire"

var ELEMENTS = ["Fire", "Ice"]
var ELEMENT_COUNT = 2
var c_elem = 0

var p_clicks = 100

var clicks = 0

onready var Bow = $Bow
onready var Gauntlets = $Gauntlets
onready var SwordSpear = $SwordSpear

onready var WEAPONS = [SwordSpear, Bow, Gauntlets]
var WEAPON_COUNT = 3
var c_weap = 0

onready var CurrentWeapon = SwordSpear

onready var anim = $AnimatedSprite

var inertia = 400

onready var high_score_screen = load("res://Main Scenes/High Scores.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	glob.player = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if dashing:
		pass
	else:
		velocity = calculate_velocity()
	
	if velocity.length() != 0 and !anim.is_playing():
		anim.play()
	elif velocity.length() == 0 and anim.is_playing():
		anim.stop()
		
	if velocity.x > 0:
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true
	
	move_and_slide(velocity, Vector2.ZERO, false, 4, PI/4, false)
	
	for i in range(0, get_slide_count()):
		var col = get_slide_collision(i)
		
		if col.collider.is_in_group("bodies"):
			col.collider.apply_central_impulse(-col.normal * inertia)

func calculate_velocity():
	var direction = get_direction()
	var velocity = direction * speed
	
	return velocity

func _input(event):
	if Input.is_action_just_pressed("dash") and !dashing:
		pass
	
	if Input.is_action_just_pressed("switch"):
		CurrentWeapon.call("switch_out")
		
		c_weap += 1
		c_weap %= WEAPON_COUNT
		CurrentWeapon = WEAPONS[c_weap]
		
		CurrentWeapon.call("switch_into")
	
	if Input.is_action_just_pressed("switch_element"):
		c_elem += 1
		c_elem %= ELEMENT_COUNT
		CurrentElement = ELEMENTS[c_elem]
		
		$"/root/global_variables".element = CurrentElement

func get_direction():
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	return direction
	
func dash():
	var direction = get_direction()
	var dash_velocity = direction * dash_speed

func update_health(change):
	$"CanvasLayer/Health Bar".health_update(change)

####################################################### Signals ####################################################
func OnSwordAreaBodyEntered(body):
	if body.has_method("update_health"):
		body.call("update_health", -50)
	elif body.has_method("explode"):
		body.call("explode")
	
func OnSwordAreaAreaEntered(area):
	var body = area.get_parent()
	
	if body.has_method("reflect"):
		var direction = (glob.get_input_direction() - global_position).normalized()
		body.call("reflect", direction)
	elif body.get_parent().has_method("stun"):
		body.get_parent().call("stun")

func OnSpearAreaBodyEntered(body):
	if body.has_method("update_health"):
		body.call("update_health", -100)
	

func OnGauntletAreaBodyEntered(body):
	if body.has_method("update_health"):
		body.call("update_health", -50)

func OnIceFieldBodyEntered(body):
	pass
