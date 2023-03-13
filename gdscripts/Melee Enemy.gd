extends KinematicBody2D


# Declare member variables here. Examples:
var player
var HUD
export var speed = 100
export var max_health = 100
onready var health = max_health

var stunned = false

const KNOCKBACK = 2000

signal score_update

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	HUD = get_parent().get_node("CanvasLayer/HUD")
	
	connect("score_update", HUD, "_score_update")
	
	add_to_group("Melee Enemies", true)

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
	var to_player = (player.position - position).normalized()
	$AnimatedSprite.position = to_player * 25
	$AnimatedSprite.look_at(player.position)
	
	$AnimatedSprite.play()

func _on_Area2D_body_entered(body):
	pass

func _on_Area2D_area_entered(area):
	stun()

func stun():
	set_physics_process(false)
	$Sprite.modulate = "#f31919"
	stunned = true
	
	yield(get_tree().create_timer(3), "timeout")
	
	set_physics_process(true)
	$Sprite.modulate = "#3af063"
	stunned = false
