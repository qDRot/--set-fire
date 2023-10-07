extends Node2D

onready var plr = get_node("/root/PlayerStats")
onready var icon_display = preload("res://assets/HUD/misc/icon_display.tscn").instance()
onready var LabelSprite = preload("res://assets/HUD/misc/eff_label.tscn")

onready var N_FRAMES = plr.N_STATES

func _ready():
	plr.connect("effect_changed", self, "redraw")
	add_child(icon_display)
	
	label_array(0.5, 45)
	

func label_array(scalar, marginy):
	var tmp = LabelSprite.instance()
	var dimensions = tmp.texture.get_size() / Vector2(tmp.hframes, tmp.vframes)
	tmp.queue_free()
	
	for i in N_FRAMES-1:
		var frame = i+1
		var label = LabelSprite.instance()
		label.frame = frame
		add_child(label)
		label.position = Vector2(dimensions.x * i * scalar, marginy)

func redraw():
	_ready()
