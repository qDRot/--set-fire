extends Sprite

func _ready():
	
	# Currect equipped effect
	if frame == 1:
		modulate.a = 1
	# Inactive effects
	else:
		modulate.r = 0.5
		modulate.g = 0.22
		modulate.b = 1
	
	# Locked effects
	if frame == 5:
		frame = 0

func get_dimensions():
	var dimensions = texture.get_size() / Vector2(get_hframes(), get_vframes())
	
	return dimensions
