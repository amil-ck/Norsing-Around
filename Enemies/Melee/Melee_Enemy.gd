extends KinematicBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var speed = 100
var max_health = 100
var KnockbackDistance = 2000

var health = max_health
onready var VarTim = $VarTim
onready var Player = get_parent().get_node("Player")
onready var HUD = get_parent().get_node("CanvasLayer/HUD")
var BLAST = load("res://Blast/Blast.tscn")

var randomness = 50

var stunned = false

signal ScoreUpdate(score)

func _ready():
	connect("ScoreUpdate", HUD, "_score_update")
	
func _process(delta):
	var velocity = calculate_velocity()
	move_and_slide(velocity)
	
func get_to_player():
	var to_player = (Player.position - position).normalized()
	return to_player
	
func get_player_distance():
	var distance = (Player.position - position).length()
	return distance
	
func calculate_velocity():
	var direction = get_to_player()
	var velocity = direction * speed
#	velocity += velocity.tangent().normalized() * randomness
	return velocity

func knockback():
	var direction = -1 * get_to_player()
	var velocity = direction * KnockbackDistance
	move_and_slide(velocity)
	
func update_health(change):
	health += change
	$Anim.play("Melee")
	knockback()
	Player.stop_loss()

	if health <= 0:
		emit_signal("ScoreUpdate", 50)
		queue_free()
	
func stun():
	$Sprite.modulate = Color("f31919")
	stunned = true
	
	VarTim.start(3)
	yield(VarTim, "timeout")
	
	$Sprite.modulate = Color("3af063")
	stunned = false
	

func OnCooldownTimeout():
	$AnimatedSprite.position = get_to_player() * 25
	$AnimatedSprite.look_at(Player.position)
	
	$Anim.play("Melee")

func OnArea2DBodyEntered(body):
	if body.has_method("update_health"):
		body.update_health(-50)


func _on_RandMov_timeout():
#	randomness *= -1
	pass
