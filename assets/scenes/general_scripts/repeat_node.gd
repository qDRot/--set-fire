extends Node2D

export (PackedScene) var Repeat
onready var repeat = [Repeat.instance()]

onready var plr = get_node("/root/PlayerStats")

var size

func _ready():
	plr.camera_follow = true
	repeat[0].position = plr.position
	add_child(repeat[0])
	size = repeat[0].size
	for i in 1:
		repeat.push_front(Repeat.instance())
		repeat[0].position = repeat[0].position + Vector2(size.x * i+1, 0)
		add_child(repeat[0])
	print(repeat)

func _process(delta):
	print(plr.position, repeat[0].position)
