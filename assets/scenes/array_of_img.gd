extends Control

func show_frames(SpriteScene, frames, xmargin, ymargin, space):
	for i in frames:
		var sprite = SpriteScene.instance()
		var dimensions = sprite.texture.get_size() / Vector2(sprite.get_hframes(), sprite.get_vframes())
		sprite.frame = i
		add_child(sprite)
		
		var position = Vector2(xmargin + dimensions.x * space * i, ymargin)
		sprite.position = position
