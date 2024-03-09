extends Node2D

var ENEMY = load("res://Enemies/Basic/Enemy.tscn")
var MELEE_ENEMY = load("res://Enemies/Melee/Melee_Enemy.tscn")

var ENEMIES = [ENEMY, MELEE_ENEMY]


func _on_Timer_timeout():
	spawn_enemy()

func spawn_enemy():
	ENEMIES.shuffle()
	var enemy = ENEMIES[0]
	
	var enemy_instance = enemy.instance()
	enemy_instance.global_position = Vector2(rand_range(-1000, 1000),
											rand_range(-1000, 1000))
	
	add_child(enemy_instance)
