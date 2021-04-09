extends Area2D

func _ready():
	$AnimatedSprite.play()
	var blood_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = blood_types[randi() % blood_types.size()]



func _on_blood_area_entered(area):
	
	modulate.a -= 0.3
	$AnimatedSprite.scale -= Vector2(0.1, 0.1)
	
	if modulate.a <= 0:
		queue_free()
