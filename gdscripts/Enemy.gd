extends KinematicBody2D


# Declare member variables here. Examples:
var player
var HUD
export var speed = 100
export var max_health = 100
onready var health = max_health

var BLAST = load("res://Blast/Blast.tscn")

const KNOCKBACK = 2000

signal score_update

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	HUD = get_parent().get_node("CanvasLayer/HUD")
	
	connect("score_update", HUD, "_score_update")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = calculate_velocity()
	move_and_slide(velocity)

func calculate_velocity():
	var to_player = (player.position - position).normalized()
	var velocity = to_player * speed
	
	return velocity

func update_health(change):
	health += change
	knockback()
	
	if health <= 0:
		emit_signal("score_update", 50)
		queue_free()

func knockback():
	var to_player = (player.position - position).normalized()
	var velocity = to_player * KNOCKBACK * -1
	
	set_physics_process(false)
	move_and_slide(velocity)
	yield(get_tree().create_timer(0.25), "timeout")
	set_physics_process(true)
	
	

func _on_Cooldown_timeout():
	var blast_instance = BLAST.instance()
	
	blast_instance.start_point = position
	blast_instance.end_point = player.position
	
	get_parent().add_child(blast_instance)
	
	blast_instance.position = position
