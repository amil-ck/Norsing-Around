extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_parent()
onready var collision_shape = player.get_node("CollisionShape2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.is_action_just_pressed("attack") and player.CurrentWeapon == self:
		sword_swing()
	
	
	if Input.is_action_just_pressed("special"):
		special()


func special():
	var value = special_check()
	
	var criteria_met = value[0]
	var target = value[1]
	
	if criteria_met:
		collision_shape.disabled = true
		
		var tp_position = target.position
		target.call("UpdateHealth", -100)
		player.position = tp_position
		$"Spear/Spear Anim".play("Spear Anim")
		
		collision_shape.disabled = false
	

func special_check():
	var criteria_met = false
	var target = null
	
	for body in get_tree().get_nodes_in_group("Melee Enemies"):
		if body.stunned:
			criteria_met = true
			target = body
	
	return [criteria_met, target]
	
	
func sword_swing():
	$Sword.position = (get_global_mouse_position() - player.position).normalized() * 50
	$Sword.look_at(get_global_mouse_position())
	$"Sword/Sword Anim".play("Sword Anim")

func SwitchOut():
	pass
	
func SwitchInto():
	pass
