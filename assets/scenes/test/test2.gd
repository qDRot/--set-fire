extends Node2D

onready var texture = get_node("TextureRect")
var size

func _ready():
	size = texture.get_rect().size
