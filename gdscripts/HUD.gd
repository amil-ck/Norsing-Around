extends Control

var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	score += delta
#	$Score.text = str(score)


func _score_update(change):
	score += change
	$Score.text = str(score)
