extends Light2D

func _process(delta):
	energy -= delta * 3
	if energy <= 0:
		queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("update_health"):
		body.call("update_health", -1 * get_process_delta_time())
