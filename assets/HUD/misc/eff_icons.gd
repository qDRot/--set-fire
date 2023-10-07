extends Sprite

onready var plr = get_node("/root/PlayerStats")

func _ready():
	# Currect equipped effect
	if frame == plr.state:
		modulate.a = 1
	# Inactive effects
	else:
		modulate = Color(1, 0, 0)
	
	if !plr.obtainedEffects.has(frame):
		frame = 0

func get_dimensions():
	var dimensions = texture.get_size() / Vector2(get_hframes(), get_vframes())
	
	return dimensions
