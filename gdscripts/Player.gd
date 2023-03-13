extends KinematicBody2D

var WIND = load("res://Player/Wind/Wind.tscn")

var speed = 200
export var controller_cursor_radius = 100
var dash_distance = 10000

var controller = false

var facing: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var velocity = calculate_velocity()
	move_and_slide(velocity)

func _input(event):
	cursor_controller(event)
	
	if Input.is_action_just_pressed("dash"):
		dash()
	
	if Input.is_action_just_pressed("attack"):
		sword_swing()
	
	if Input.is_action_just_pressed("special"):
		special()
	
func calculate_velocity():
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	if direction.length() != 0:
		facing = direction
	
	var velocity = direction * speed
	return velocity

func sword_swing():
	if controller:
		var direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
		$Sword.position = direction * 30
		$Sword.look_at(position + direction * 100)
	else:
		$Sword.position = (get_global_mouse_position() - position).normalized() * 30
		$Sword.look_at(get_global_mouse_position())
		
		
	$"Sword/Sword Anim".play("Sword Anim")

func special():
	var criteria_met = false
	var target
	
	for body in $"Stunned Attack".get_overlapping_bodies():
		if body.is_in_group("Melee Enemies"):
			if body.stunned:
				criteria_met = true
				target = body
	
	if criteria_met:
		var tp_position = target.position
		target.update_health(-100)
		position = tp_position
		$"Spear/Spear Anim".play("New Anim")
	
func cursor_controller(event):
	if event is InputEventMouse or event is InputEventMouseButton or event is InputEventKey:
		controller = false
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		controller = true
	
	#Controller input
	var normalized_cursor = Vector2(
		Input.get_joy_axis(0, 2),
		Input.get_joy_axis(0, 3)
	).normalized()
	
	#is there a value in normalized_cursor (is there a controller input)
	if normalized_cursor.length() == 0:
		$Cursor.visible = false
		if event is InputEventMouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		var cursor_position = normalized_cursor * controller_cursor_radius
		$Cursor.position = cursor_position
		$Cursor.visible = true

func dash():
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	var dash_change = direction * dash_distance

	var start_point = position	
	$CollisionShape2D.disabled = true
	move_and_slide(dash_change)
	$CollisionShape2D.disabled = false
	var end_point = position
	
	make_wind(start_point, end_point)
	
func make_wind(start, end):
	var wind = WIND.instance()
	
	wind.start_point = start
	wind.end_point = end
	
	get_parent().add_child(wind)


func _on_Hit_detector_body_entered(body):
	if body.collision_layer == 2 and body.has_method("update_health"):
		body.update_health(-50)
	elif body.collision_layer == 16 and body.has_method("reflect"):
		if controller:
			body.reflect(facing)
		else:
			var direction = (get_global_mouse_position() - position).normalized()
			body.reflect(direction)


func _on_Hit_detector_area_entered(area):
	if area.collision_layer == 16 and area.get_parent().has_method("reflect"):
		if controller:
			area.get_parent().reflect(facing)
		else:
			var direction = (get_global_mouse_position() - position).normalized()
			area.get_parent().reflect(direction)

func _on_Spear_Area_body_entered(body):
	body.update_health(-100)
