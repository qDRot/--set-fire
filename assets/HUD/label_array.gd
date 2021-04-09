extends Control

# Image scene to use. Lables in our case
export (PackedScene) var Img

# Used to automatically pad from
# the image above
export (PackedScene) var ImgBefore

# Frames to iterate
const N_FRAMES = 6

# Get script node
onready var scr = get_parent().get_node("imageArray_script")


func _ready():
	# Calculate dimensions in image above
	# and set y axis margin by it
	var dimension = ImgBefore.instance().get_dimensions().y
	var marginy = dimension
	
	# Show all frames, reduce space between objects
	scr.show_frames(Img, N_FRAMES, -3, marginy-8, 0.5)
