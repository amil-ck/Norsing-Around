extends KinematicBody2D

var start_point = Vector2.ZERO
var end_point = Vector2.ZERO


var direction = Vector2.ZERO
var velocity = Vector2.ZERO

var speed = 500


# Called when the node enters the scene tree for the first time.
func _ready():
	direction = (end_point - start_point).normalized()
	velocity = direction * speed
	
	position = start_point


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity)


func reflect(new_direction):
	direction = new_direction
	velocity = direction * speed
	
	$Area2D.collision_layer = 4
	$Area2D.collision_mask = 2


func _on_Area2D_body_entered(body):
	if body.has_method("UpdateHealth"):
		body.call("UpdateHealth", -50)
	
	queue_free()
