extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Player;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.is_action_just_pressed("special"):
		go_to_player()

func go_to_player():
	pass
