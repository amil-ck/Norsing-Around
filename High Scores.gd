extends Node2D

var path = "res://scores.json"
var score

func _ready():
	if $"/root/global_variables".score_scene_type == "game":
		score = $"/root/global_variables".score
		$"/root/global_variables".score = 0
	elif $"/root/global_variables".score_scene_type == "menu":
		$"Submit Name".hide()
		var data = load_scores()
		display_score(data)
		$"Scores/Play Again".text = "Play Game"

func load_scores():
	var file = File.new()
	var text = "{}"
	
	if file.file_exists(path):
		file.open(path, file.READ)
		text = file.get_as_text()
		
	var data = parse_json(text)
	
	file.close()
		
	return data

func add_score(data, name, score):
	if len(data) == 10 and data[9]["score"] < score:
		data.pop(9)
	
	if len(data) < 10:
		for i in range(len(data)):
			var item = data[i]
			if item["score"] < score:
				data.insert(i, parse_json('{"name" : "' + name + '", "score" : ' + str(score) + '}'))
				return data
		
		data.append(parse_json('{"name" : "' + name + '", "score" : ' + str(score) + '}'))
	
	return data

func write_score(data):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(to_json(data))
	file.close()

func display_score(data):
	$"Submit Name".hide()
	
	var y = 10
	for item in data:
		var new_text = Label.new()
		new_text.text = item["name"] + "       " + str(int(item["score"]))
		new_text.set_global_position(Vector2(0, y))
		$Scores.add_child(new_text)
		
		y += 20
	
	$Scores.visible = true

func _on_Button_pressed():
	var data = load_scores()
	var new_data = add_score(data, $"Submit Name/Name".text, score)
	print(new_data)
	display_score(new_data)


func _on_Play_Again_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_Main_Menu_pressed():
	get_tree().change_scene("res://Menu.tscn")
