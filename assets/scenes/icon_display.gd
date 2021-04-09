extends Control

export (PackedScene) var Icon
onready var scr = get_parent().get_node("imageArray_script")

func _ready():
	var icon = Icon.instance()
	icon.frame = 1
	add_child(icon)
