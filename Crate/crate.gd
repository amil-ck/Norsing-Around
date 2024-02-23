extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func explode():
	$CollisionShape2D.call_deferred("set", "disabled", true)
	
	$Sprite.visible = false
	$Broken.visible = false
	
	for i in [$piece1, $piece2, $piece3]:
		i.visible = true
		
		var new_position = Vector2(rand_range(-20, 20), rand_range(-20, 20))
		var new_rotation = rand_range(-PI, PI)
		var new_modulate = modulate
		new_modulate.a = 0
		
		$Tween.interpolate_property(i, "position", Vector2(0, 0), new_position, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		$Tween.interpolate_property(i, "rotation", rotation, new_rotation, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
		$Tween.interpolate_property(i, "modulate", modulate, new_modulate, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		
	$Tween.start()

func UpdateHealth(change):
	health += change
	
	if health <= 0:
		explode()
	elif health <= 50:
		$Sprite.visible = false
		$Broken.visible = true
	
