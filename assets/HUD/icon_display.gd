extends Control

export (PackedScene) var Icon
onready var scr = get_parent().get_node("imageArray_script")

# TEMPORALY!!!
var curr_eff = 1

func _ready():
	var icon = Icon.instance()
	icon.frame = curr_eff
	add_child(icon)
