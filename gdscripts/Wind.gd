extends Sprite

var start_point: Vector2
var end_point: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	position = (start_point + end_point) / 2
	rotation = start_point.angle_to_point(end_point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_a = modulate.a - 0.7 * delta
	
	if new_a <= 0:
		queue_free()
	else:
		modulate.a = new_a
