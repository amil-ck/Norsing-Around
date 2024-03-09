extends Control

func _process(delta):
	$TextureProgress.value += delta
	
	if $TextureProgress.value >= 10:
		$TextureProgress.value = 0
		get_parent().get_parent().switch()
