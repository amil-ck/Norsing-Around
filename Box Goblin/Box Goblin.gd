extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2.ZERO
var speed = 10000


# Called when the node enters the scene tree for the first time.
func _ready():
	change_direction()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(direction * speed * delta)

func change_direction():
	direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	
	if direction.x > 0:
		$AnimatedSprite.flip_h = true
	elif direction.x < 0:
		$AnimatedSprite.flip_h = false
	
	
	$Timer.start()



func _on_Timer_timeout():
	change_direction()
	
	$Timer.wait_time = rand_range(0, 5)
