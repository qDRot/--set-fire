extends Node

class_name PlayerStat

const DEFAULT_SPEED = 90

# For now it's defined manually
# number of states 
const N_STATES = 6

signal effect_changed

# Animation variables
var anim_U:String
var anim_D:String
var anim_R:String
var anim_L:String
var anim_act:String

# States
enum e {
	NORMAL,
	CLEAN,
	KNIFE,
	GOMI,
	KOMA_A,
	SICK,
	SCHOOL,
	KOMA_UM = 30
}

# Player plr.state
enum {
	NONE,
	ACT,
	WALK
}

const Pause = preload("res://assets/HUD/pause.tscn")
var pause

# Default plr.states
var action = NONE
var stun = false
export var speed:int = DEFAULT_SPEED
var collide = false
var position := Vector2.ZERO
var camera_follow = true

var obtainedEffects = [e.NORMAL, e.CLEAN, e.KNIFE, e.GOMI, e.KOMA_A, e.SICK]
var state

func _ready():
	if state == null:
		state = e.SCHOOL
	pause = Pause.instance()
	add_child(pause)

# Add effect to obtained effects list
func add_effect(effect):
	obtainedEffects.push_back(effect)

# Get array of obtained effects
func get_obtained():
	return obtainedEffects

# Get array of unobtained effects
func get_unobtained():
	var num_unobtained = states_left()
	var unobtainedEffects = []
	for i in N_STATES:
		if obtainedEffects.has(i):
			pass
		else:
			unobtainedEffects.insert(0, i)
	
	return unobtainedEffects

# Get number of effects not yet collected
func states_left():
	var num_unobtained = N_STATES - obtainedEffects.size()
	return num_unobtained

# Return dictionary with effects 
# and their order of collection
# { <order>: "<name>" }
# Example: { 1: KNIFE }
func list_effects():
	var eff = e.keys()
	var dict = {}
	
	for x in obtainedEffects.size():
		dict[x] = eff[obtainedEffects[x]]
		
	return dict

func change_effect():
	var numKey = [KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]
	
	for i in obtainedEffects.size():
		if Input.is_key_pressed(numKey[i]):
			reloadEffect(obtainedEffects[i])
			emit_signal("effect_changed")

# Reload effect
func reloadEffect(effect:int):
	speed = DEFAULT_SPEED
	state = effect
	animation_tree()

# Animation tree set
func animation_tree():
	# Normal
	if state == e.NORMAL:
		anim_L = "norm_L"
		anim_R = "norm_R"
		anim_U = "norm_U"
		anim_D = "norm_D"
		anim_act = "default"
	# Broom
	elif state == e.CLEAN:
		anim_L = "clean_L"
		anim_R = "clean_R"
		anim_U = "clean_U"
		anim_D = "clean_D"
		anim_act = "clean_happy"
	# Knife
	elif state == e.KNIFE:
		anim_L = "knife_L"
		anim_R = "knife_R"
		anim_U = "knife_U"
		anim_D = "knife_D"
		anim_act = "knife_cut"
	# Trash
	elif state == e.GOMI:
		anim_L = "gomi_L"
		anim_R = "gomi_R"
		anim_U = "gomi_U"
		anim_D = "gomi_D"
		anim_act = "gomi_hide"
	# Komainu
	elif state == e.KOMA_A:
		anim_L = "koma_a_L"
		anim_R = "koma_a_R"
		anim_U = "koma_U"
		anim_D = "koma_a_D"
		anim_act = "koma_close"
	elif state == e.KOMA_UM:
		anim_L = "koma_um_L"
		anim_R = "koma_um_R"
		anim_U = "koma_U"
		anim_D = "koma_um_D"
		anim_act = "koma_open"
	elif state == e.SICK:
		anim_L = "sick_L"
		anim_R = "sick_R"
		anim_U = "sick_U"
		anim_D = "sick_D"
		anim_act = "sick_act"
	elif state == e.SCHOOL:
		anim_L = "school_L"
		anim_R = "school_R"
		anim_U = "school_U"
		anim_D = "school_D"
