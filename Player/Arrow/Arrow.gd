extends KinematicBody2D

var velocity
var speed = 2000

onready var FIRE = load("res://Player/Arrow/Fire.tscn")

# Called when the node enters the scene tree for the first time.
func init(start, end):
	position = start
	rotation = get_angle_to(end) + (PI/2)
	
	var direction = (end - start).normalized()
	velocity = direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity)
	
	var fire = FIRE.instance()
	fire.position = position
	get_parent().add_child(fire)
	
	if position.distance_to(get_parent().position) > 5000:
		queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("update_health"):
		body.update_health(-50)
		queue_free()
