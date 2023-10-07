extends Control

onready var console = get_node("Console")
onready var label = get_node("PanelContainer/Label")
onready var plr = get_node("/root/PlayerStats")

var pause_menu

func _ready():
	pause_menu = false
	hide()

func _process(delta):
	input()
	plr.change_effect()

func input():
	if Input.is_action_just_pressed("ui_cancel") && console.state == console.State.NORMAL:
		unpause() if is_visible_in_tree() else pause()

func pause():
	pause_menu = true
	show()
	get_tree().paused = true

func unpause():
	pause_menu = false
	hide()
	get_tree().paused = false

func console_mode():
	if console.state == console.State.INPUT:
		label.text = "-INPUT-"
	elif console.state == console.State.NORMAL:
		label.text = "-NORMAL-"
	elif console.state == console.State.SEARCH:
		label.text = "-SEARCH-"

func _on_Console_change_mode():
	console_mode()

func is_on_pause():
	return pause_menu
