extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction
var start_point
var end_point
var velocity
var speed = 2000
var element

onready var FIRE = load("res://Player/Arrow/Fire.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = (end_point - start_point).normalized()
	velocity = direction * speed
	
	position = start_point
	rotation = get_angle_to(end_point) + PI/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity)
	
	if element == "Fire":
		var fire = FIRE.instance()
		fire.position = position
		get_parent().add_child(fire)
	
	if position.distance_to(get_parent().position) > 5000:
		queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("UpdateHealth"):
		body.UpdateHealth(-50)
		queue_free()
