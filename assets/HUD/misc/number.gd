extends Label

onready var lab = get_parent()
onready var plr = get_node("/root/PlayerStats")

func _ready():
	if plr.obtainedEffects.has(lab.frame):
		text = str(plr.obtainedEffects.find(lab.frame))
	else:
		queue_free()
