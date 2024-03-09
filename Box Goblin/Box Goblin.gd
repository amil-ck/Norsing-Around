extends KinematicBody2D

var direction = Vector2.ZERO
var speed = 10000

var BOX = load("res://Crate/crate.tscn")

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
	
	$SwitchTim.start()
	
func _on_SwitchTim_timeout():
	change_direction()
	$SwitchTim.wait_time = rand_range(0, 5)

func _on_BoxTim_timeout():
	var box = BOX.instance()
	box.global_position = global_position + Vector2(rand_range(-100, 100),
													rand_range(-100, 100))
	get_tree().current_scene.add_child(box)
