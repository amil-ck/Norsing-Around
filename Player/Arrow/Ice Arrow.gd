extends KinematicBody2D

var velocity
var speed = 2000

# Called when the node enters the scene tree for the first time.
func init(start, direction):
	direction = direction.normalized()
	
	velocity = direction * speed
	
	position = start
	rotation = get_angle_to(start + direction) + PI/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_and_slide(velocity)
	
	if position.distance_to(get_parent().position) > 5000:
		queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("update_health"):
		body.update_health(-50)
		queue_free()
