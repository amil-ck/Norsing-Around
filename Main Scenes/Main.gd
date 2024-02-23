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
	add_child(enemy_instance)
