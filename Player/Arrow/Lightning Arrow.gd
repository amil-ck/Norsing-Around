extends KinematicBody2D

var velocity
var speed = 2000

func init(start, end):
	var direction = (end - start).normalized()
	velocity = direction * speed
	
	position = start
	rotation = get_angle_to(end) + PI / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_and_slide(velocity)
	
	var node = get_tree().get_nodes_in_group("Lightning Arrow")[0]
	draw_line(global_position, node.position, Color(255, 255, 0), 100)


func _on_Area2D_body_entered(body):
	if body.has_method("update_health"):
		body.call("update_health", -50)
