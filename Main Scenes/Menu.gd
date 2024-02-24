extends Node2D

func _on_Start_Game_pressed():
	get_tree().change_scene("res://Main Scenes/Main.tscn")

func _on_High_Score_pressed():
	get_tree().change_scene("res://Main Scenes/High Scores.tscn")

func _on_Quit_pressed():
	get_tree().quit()
