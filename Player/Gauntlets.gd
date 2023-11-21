extends Node2D

onready var player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.CurrentWeapon == self:
		gauntlet_controller()


func gauntlet_controller():
	position = (get_global_mouse_position() - player.position).normalized() * 50
	rotation = player.get_angle_to(get_global_mouse_position()) + PI/2
	
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("Attack")
	
	if Input.is_action_just_pressed("block"):
		pass
		
func SwitchInto():
	show()

func SwitchOut():
	hide()
