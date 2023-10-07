extends Camera2D

onready var plr = get_node("/root/PlayerStats")

func _process(delta):
	if plr.camera_follow:
		current = true
		position = plr.position
	else:
		current = false
