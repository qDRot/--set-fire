extends Sprite

# TEMPORALY!!!!!
var obtainedEffects = [0, 1, 3, 4]
var curr_eff = 3

func _ready():
	# Currect equipped effect
	if frame == curr_eff:
		modulate.a = 1
	# Inactive effects
	else:
		modulate.a = 0.5
	
	if !obtainedEffects.has(frame):
		frame = 0

func get_dimensions():
	var dimensions = texture.get_size() / Vector2(get_hframes(), get_vframes())
	
	return dimensions
