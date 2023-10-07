extends Control

const SCROLL_SPEED = 7

onready var input = get_node("vertical/in")
onready var output = get_node("vertical/HBoxContainer/out")
onready var text = get_node("vertical/HBoxContainer/text")

onready var com = get_node("commands")

enum State {
	SEARCH,
	INPUT,
	NORMAL
}

var state = State.NORMAL
var current_line := 0

signal exitted
signal change_mode

func _ready():
	default_highlight()
	placeholder()

func _process(delta):
	controls()

func controls():
	match state:
		State.INPUT:
			if Input.is_action_just_pressed("ui_up"):
				current_line += 1
				set_input_text(output.get_line(current_line))
			elif Input.is_action_just_pressed("ui_down"):
				current_line -= 1
				set_input_text(output.get_line(current_line))
			continue
		State.SEARCH:
			if Input.is_key_pressed(KEY_N):
				scroll_down(text, 4)
			if Input.is_key_pressed(KEY_B):
				scroll_up(text, 4)
			continue
		State.NORMAL:
			if Input.is_action_pressed("ui_down"):
				scroll_down(text, 1)
			elif Input.is_action_pressed("ui_up"):
				scroll_up(text, 1)
			continue
		_:
			if Input.is_action_just_pressed("colon") && !input.has_focus():
				focus_and_write(":")
			if Input.is_action_just_pressed("search") && !input.has_focus():
				focus_and_write("/")
			if Input.is_action_just_pressed("ui_cancel"):
				exit_console()
	
			if Input.is_action_just_pressed("ui_page_down"):
				scroll_down(text, SCROLL_SPEED)
			elif Input.is_action_just_pressed("ui_page_up"):
				scroll_up(text, SCROLL_SPEED)

func set_input_text(string):
	input.text = string
	input.set_cursor_position(string.length())

func scroll_up(node, value:int):
	node.set_v_scroll(node.scroll_vertical - value)
	
func scroll_down(node, value:int):
	node.set_v_scroll(node.scroll_vertical + value)

func focus_and_write(string:String):
	state = State.INPUT
	emit_signal("change_mode")
	
	input.grab_focus()
	set_input_text(string)

func exit_console():
	state = State.NORMAL
	emit_signal("change_mode")
	
	input.clear()
	input.release_focus()
	emit_signal("exitted")

func _on_in_text_entered(new_text):
	exit_console()
	com.process_command(new_text)

func output_text(text):
	output.text = str(text, "\n", output.text)

# Text in input box
func placeholder():
	input.placeholder_text = "\".nwrldrc\"" + " " + str(text.get_line_count()) + "L"

func set_placeholder(text):
	input.placeholder_text = text

func default_highlight():
	pass
	text.add_keyword_color("help", Color(0, 0.2, 1))
	text.add_color_region(":", " ", Color(1, 1, 0))

func _on_Console_exitted():
	placeholder()
	text.clear_colors()
	default_highlight()
