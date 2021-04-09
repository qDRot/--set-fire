extends Control


export (PackedScene) var Img

const N_FRAMES = 6

onready var scr = get_parent().get_node("imageArray_script")

func _ready():
	scr.show_frames(Img, N_FRAMES, 0, 0, 1)

