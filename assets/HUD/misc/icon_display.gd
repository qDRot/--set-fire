tool
extends Control

export (PackedScene) var Icon

onready var plr = get_node("/root/PlayerStats")

func _ready():
	var icon = Icon.instance()
	icon.frame = plr.state
	add_child(icon)
