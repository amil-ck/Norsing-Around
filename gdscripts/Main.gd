extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enemy = load("res://Enemies/Basic/Enemy.tscn")
var melee_enemy = load("res://Enemies/Melee/Melee_Enemy.tscn")

var enemies = [enemy, melee_enemy]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_enemy():
	var chosen_enemy = enemies[randi() % enemies.size()]
	
	var enemy_instance = chosen_enemy.instance()
	add_child(enemy_instance)
	enemy_instance.position = Vector2(0, 0)
	
func _on_Timer_timeout():
	spawn_enemy()
