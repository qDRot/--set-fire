extends Control


export (PackedScene) var Img
export (PackedScene) var ImgBefore

const N_FRAMES = 6

onready var scr = get_parent().get_node("imageArray_script")

func _ready():
	var dimension = ImgBefore.instance().get_dimensions().y
	var marginy = dimension
	scr.show_frames(Img, N_FRAMES, -10, marginy, 0.5)
