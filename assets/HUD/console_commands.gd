extends Control

onready var console = get_parent()

enum {
	INT,
	STRINGS,
	BOOL,
	FLOAT
}

const SAVES = "res://saves/"
const HELP = str(SAVES + "help.md")

const valid_commands = [
	["write", ":w", STRINGS],
	["write", ":write", STRINGS],
	["load_save", ":load", STRINGS],
	["load_save", ":l", STRINGS],
	["open", ":o", STRINGS],
	["open", ":open", STRINGS],
	["quit", ":q"],
	["quit", ":q!"],
	#["timeshift", ":earlier", INT],
	["help", ":help"],
	["help", ":h"],
	#["set", ":set", STRINGS]
]

func process_command(text):
	if text[0] == "/":
		search_for(text, console.text)
		return
	
	var commands = Array(text.split(" "))
	print(commands)
	for c in valid_commands:
		if c[1] == commands[0]:
			if commands.size()>1 && c.size()>2:
				call(c[0], commands[1])
			else:
				call(c[0])
			break
	console.output_text(text)

func write(input := "1"):
	var path = SAVES + input + ".conf"
	save_to(console.text.text, path)
	console.set_placeholder(str("[SAVED ON: ", path, "]"))

func load_save(input := "1"):
	var path = SAVES + input + ".conf"
	console.text.text = load_from(path)
	console.set_placeholder(str("[LOADED ", path, " CONFIG]"))

func open(input):
	var path = SAVES + input
	console.text.text = load_from(path)

func help():
	console.text.text = load_from(HELP)

func quit():
	print("quitting the game")

# Search for RegEx
func search_for(text:String, node):
	# Set console state to SEARCH
	console.state = console.State.SEARCH
	console.emit_signal("change_mode")
	
	# Copy input w/o first symbol
	var pattern:String
	for i in text.length()-1:
		pattern += text[i+1]
	
	# Search for pattern
	var regex = RegEx.new()
	regex.compile(pattern)
	var matches = regex.search_all(node.text)
	
	# Copy found strings to string array
	var strings = []
	for i in matches.size():
		strings.push_back((matches[i].get_strings())[0])
	
	# Highlight found words with color
	node.clear_colors()
	for i in strings.size():
		node.add_keyword_color(strings[i], Color(1, 0, 0))
	console.set_placeholder(str("[MATCHES FOR \"", pattern, "\": ", strings.size(), "]"))

# Save to file
func save_to(string:String, path:String):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(string)
	file.close()

# Load from file
func load_from(path:String) -> String:
	var content:String
	var file = File.new()
	
	if file.file_exists(path):
		file.open(path, File.READ)
		content = file.get_as_text()
		file.close()
		return content
	else:
		return str("File ", path, " not found")
