extends KinematicBody2D


# Declare member variables here. Examples:
var start_point
var end_point

var direction

var speed = 500
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = (end_point - start_point).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = direction * speed
	move_and_slide(velocity)

func reflect(new_direction):
	direction = new_direction
	$Area2D.collision_layer = 4
	$Area2D.collision_mask =  2


func _on_Area2D_body_entered(body):
	if body.has_method("update_health"):
		body.update_health(-50)
#	queue_free()
