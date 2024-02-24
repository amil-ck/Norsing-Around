extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	var player = area.get_parent()
	if player.has_method("initiate_parry"):
		player.call("initiate_parry")

func OnSwordAreaBodyEntered(body):
	if body.has_method("update_health"):
		body.call("update_health")

#func OnSwordAreaAreaEntered(area):
#	if area.get_parent().has_method("reflect"):
#		var direction = glob.get_input_direction() - position).normalized()
