extends KinematicBody2D

var direction = Vector2.ZERO
var velocity = Vector2.ZERO

var speed = 500

func init(start, end):
	direction = (end - start).normalized()
	velocity = direction * speed
	
	position = start

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
