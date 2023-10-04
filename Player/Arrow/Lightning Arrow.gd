extends KinematicBody2D

var start_point
var end_point

var speed = 2000

onready var direction = (end_point - start_point).normalized()
onready var velocity = direction * speed

func _ready():
	position = start_point
	rotation = get_angle_to(end_point) + PI / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity)
	
	var node = get_tree().get_nodes_in_group("Lightning Arrow")[0]
	draw_line(global_position, node.position, Color(255, 255, 0), 100)


func _on_Area2D_body_entered(body):
	if body.has_method("UpdateHealth"):
		body.call("UpdateHealth", -50)
