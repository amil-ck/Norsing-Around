extends KinematicBody2D

export var speed = 400
export var dashing = false
export var dash_speed = 5000

var joystick = false

var max_health = 100
onready var health = max_health

var CurrentElement = "Fire"

var ELEMENTS = ["Fire", "Electricity", "Ice"]
var ELEMENT_COUNT = 3
var c_elem = 0

var p_clicks = 100

var clicks = 0

onready var Bow = $Bow
onready var Gauntlets = $Gauntlets
onready var SwordSpear = $SwordSpear

onready var WEAPONS = [Bow, Gauntlets, SwordSpear]
var WEAPON_COUNT = 3
var c_weap = 0

onready var CurrentWeapon = SwordSpear

onready var anim = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if dashing:
		velocity
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
	
	move_and_slide(velocity)


func calculate_velocity():
	var direction = get_direction()
	var velocity = direction * speed
	
	return velocity

func _input(event):
	if Input.is_action_just_pressed("dash") and !dashing:
		pass
	
	if Input.is_action_just_pressed("switch"):
		CurrentWeapon.call("SwitchOut")
		
		c_weap += 1
		c_weap %= WEAPON_COUNT
		CurrentWeapon = WEAPONS[c_weap]
		
		CurrentWeapon.call("SwitchInto")
	
	if Input.is_action_just_pressed("switch_element"):
		c_elem += 1
		c_elem % ELEMENT_COUNT
		CurrentElement = ELEMENTS[c_elem]

func get_direction():
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	return direction

func dash():
	var direction = get_direction()
	var dash_velocity = direction * dash_speed

func UpdateHealth(change):
	health += change
	if health <= 0:
		pass

func init_parry():
	clicks = 0
	
func click():
	clicks += 1
	
	if clicks >= 100:
		pass


####################################################### Signals ####################################################
func OnSwordAreaBodyEntered(body):
	if body.has_method("UpdateHealth"):
		body.call("UpdateHealth", -50)
	
func OnSwordAreaAreaEntered(area):
	var body = area.get_parent()
	
	if body.has_method("reflect"):
		var direction = (get_global_mouse_position() - global_position).normalized()
		body.call("reflect", direction)
	elif body.get_parent().has_method("stun"):
		body.get_parent().call("stun")

func OnSpearAreaBodyEntered(body):
	if body.has_method("UpdateHealth"):
		body.call("UpdateHealth", -100)
	

func OnGauntletAreaBodyEntered(body):
	if body.has_method("UpdateHealth"):
		body.call("UpdateHealth", -50)

func OnIceFieldBodyEntered(body):
	pass
