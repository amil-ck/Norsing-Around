extends KinematicBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var speed = 100
var max_health = 100
var knockback_distance = 2000

var health = max_health
onready var VarTim = $VarTim
onready var glob = get_node("/root/global_variables")
onready var Player = glob.player
onready var HUD = get_parent().get_node("CanvasLayer/HUD")
var BLAST = load("res://Blast/Blast.tscn")

signal ScoreUpdate(score)

func _ready():
	connect("ScoreUpdate", HUD, "_score_update")
	
func _process(delta):
	if get_player_distance() > 500:
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
	return velocity

func knockback():
	var direction = -1 * get_to_player()
	var velocity = direction * knockback_distance
	move_and_slide(velocity)
	
func update_health(change):
	health += change
	$AnimationPlayer.play("Anim")
	knockback()
	Player.stop_loss()

	if health <= 0:
		emit_signal("ScoreUpdate", 50)
		queue_free()

func OnCooldownTimeout():
	var blast = BLAST.instance()
	blast.init(position, Player.position)
	get_parent().add_child(blast)
	
