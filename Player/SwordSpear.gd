extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ice_attacking = false

onready var player = get_parent()
onready var collision_shape = player.get_node("CollisionShape2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.CurrentWeapon == self and player.CurrentElement == "Ice":
		$"Ice Spear".show()
		
		if not ice_attacking:
			$"Ice Spear".position = (get_global_mouse_position() - player.position).normalized() * 60
			$"Ice Spear".rotation = player.get_angle_to(get_global_mouse_position()) + PI / 2
		
	else:
		$"Ice Spear".hide()

func _input(event):
	if Input.is_action_just_pressed("attack") and player.CurrentWeapon == self:
		if player.CurrentElement == "Fire":
			sword_swing()
		elif player.CurrentElement == "Ice" and not ice_attacking:
			ice_stab(get_global_mouse_position())
	
	
	if Input.is_action_just_pressed("special"):
		special()


func special():
	var value = special_check()
	
	var criteria_met = value[0]
	var target = value[1]
	
	if criteria_met:
		collision_shape.disabled = true
		
		target.call("UpdateHealth", -100)
		player.position = target.position
		$"Spear/Spear Anim".play("Spear Anim")
		
		collision_shape.disabled = false
	
func ice_stab(mouse_pos):
	$"Ice Spear".rotation = player.get_angle_to(mouse_pos) + PI / 2
	var original_pos = $"Ice Spear".position
	var new_position = (mouse_pos - player.position).normalized() * 150
	ice_attacking = true
	$"Ice Spear/Ice Spear Area/CollisionShape2D".disabled = false
	
	$"Ice Tween".interpolate_property($"Ice Spear", "position", $"Ice Spear".position, $"Ice Spear".position * 0.7, 0.3)
	$"Ice Tween".start()
	yield($"Ice Tween", "tween_completed")
	$"Ice Tween".interpolate_property($"Ice Spear", "position", $"Ice Spear".position, new_position, 0.2)
	$"Ice Tween".start()
	yield($"Ice Tween", "tween_completed")
	$"Ice Tween".interpolate_property($"Ice Spear", "position", $"Ice Spear".position, original_pos, 0.2)
	$"Ice Tween".start()
	yield($"Ice Tween", "tween_completed")
	
	$"Ice Spear/Ice Spear Area/CollisionShape2D".disabled = true
	ice_attacking = false

func interp_ice(new_pos, time):
	$"Ice Tween".interpolate_property($"Ice Spear", "position", $"Ice Spear".position, $"Ice Spear".position * 0.7, 0.3)
	$"Ice Tween".start()
	yield($"Ice Tween", "tween_completed")



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

func _on_Ice_Spear_Area_body_entered(body):
	if body.is_in_group("enemies") or body.is_in_group("bodies"):
		body.call("UpdateHealth", -50)
