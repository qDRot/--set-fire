extends Control

onready var plr = get_node("/root/PlayerStats")

func _ready():
	plr.camera_follow = true
