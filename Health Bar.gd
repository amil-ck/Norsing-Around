extends Control

var max_health = 150
var hearts = 3
var heart_list = []
var blue_list = []

func _ready():
	for i in range(hearts):
		heart_list.append(get_node(str(i)))

func _process(delta):
	if blue_list != []:
		if blue_list[0].frame == 7:
			blue_list.pop_front()
		
		if blue_list != []:
			if blue_list[0].animation == "Drain":
				var temp = blue_list[0].frame
				blue_list[0].play("Grey Drain")
				blue_list[0].frame = temp
			else:
				blue_list[0].play("Grey Drain")
			
func _input(event):
	if Input.is_action_just_pressed("special") and blue_list != []:
		var front = blue_list.pop_front()
		front.stop()
		var temp_frame = front.frame
		front.animation = "Drain"
		front.frame = temp_frame
		
		blue_list.invert()
		
		while blue_list != []:
			var heart = blue_list.pop_front()
			heart.play("default")
			heart_list.insert(0, heart)
		
		heart_list.insert(0, front)


func health_update(change, health):
	if heart_list != []:
		var lost_ratio = (-float(change) / max_health) * hearts
		print(lost_ratio)
		
		for i in range(lost_ratio):
			var blue = heart_list.pop_front()
			var temp = blue.frame
			if temp == 0:
				blue.play("Grey-ed")
			blue.frame = temp
			blue_list.append(blue)
