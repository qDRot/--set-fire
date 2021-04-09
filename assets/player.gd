extends Area2D

export (PackedScene) var Blood

const DEFAULT_SPEED = 90

# Effects
enum {
	NORMAL,
	CLEAN,
	KNIFE,
	GOMI,
	KOMA_A,
	SICK,
	KOMA_UM = 30
}

# TEMPORALLY!!!!!
var obtainedEffects = [NORMAL, SICK, CLEAN, GOMI, KNIFE]

# Player state
enum {
	NONE,
	ACT,
	WALK
}


# Default states
export var state = KNIFE
export var speed:int = DEFAULT_SPEED
export var action = NONE
export var stun = false

# Screen size
var screen_size

# Timer
onready var timer = get_node("Timer")
var timer_run = false

# Collision
onready var broomColis = get_node("Broom/Broom_Collision")

# Animation variables
var anim_U:String
var anim_D:String
var anim_R:String
var anim_L:String
var anim_act:String

# When loading a node prepare animation tree
# and get screen size
func _ready():
	$AnimatedSprite.set_process_input(true)
	animation_tree()
	screen_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))

# Running every frame
func _process(delta):
	var velocity = input()
	debug()
	effects()
	
	# Change position of node 
	position += velocity * delta

	# Restrict to screen size
	restrict_to_screen()
	
	animate(velocity)

"""
Input & control
"""
# Function that describes input
# Returns: Vector2D velocity
func input():

	var velocity = Vector2()

	# Movement
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1

	# Action
	if Input.is_action_just_pressed("key_action"):
		velocity = Vector2(0, 0)
		action = ACT
		$AnimatedSprite.animation = anim_act
		$AnimatedSprite.play()

	if Input.is_action_just_pressed("ui_cancel"):
		stunToggle()

	# Get velocity from input if not stunned
	if !stun:
		pass
	else:
		velocity = Vector2(0, 0)

	# Play animation when moving, stop on frame 1
	# when standing, set current action
	if velocity.length() > 0:
		action = WALK
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	elif velocity.length() <= 0 && action != ACT:
		action = NONE
		$AnimatedSprite.frame = 1
		$AnimatedSprite.stop()
	
	$VelocityDebug.text = str(velocity)
	
	return velocity

# Stun for time
func stun_for(time):
	timer.set_wait_time(time)
	timer.start()
	stun = true

# Stun until the end of animation
func stun_4anim(anim):
	var num_frames = get_animation_frames(anim)
	if $AnimatedSprite.frame < num_frames - 1:
		stun = true
	else:
		stun = false

# Toggle stun state
func stunToggle():
	stun = false if stun else true

# Sets animations to actions
func animate(velocity):
	if velocity.x > 0:
		$AnimatedSprite.animation = anim_R
	elif velocity.x < 0:
		$AnimatedSprite.animation = anim_L
	elif velocity.y < 0:
		$AnimatedSprite.animation = anim_U
	elif velocity.y > 0:
		$AnimatedSprite.animation = anim_D

# Restricts player movement to screen
func restrict_to_screen():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

"""
Effects
"""
# Effect-specific actions
func effects():
	
	var numKey = [KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]
	
	if action != ACT:
		print(obtainedEffects.size())
		for i in obtainedEffects.size():
			if Input.is_key_pressed(numKey[i]):
				reloadEffect(obtainedEffects[i])
	
	match state:
	# Trash effect
		GOMI:	
			# Stun on action
			if Input.is_action_just_pressed("key_action"):
				stun = false if stun else true
				# Unstun in second action
				# Play unhide animation
				if !stun:
					anim_act = "gomi_unhide"
					$AnimatedSprite.animation = anim_act
					$AnimatedSprite.play()
					animation_tree()
		
	# Knife effect
		KNIFE:
			# Spawn blood on drop_frame frame
			# on blood_position point
			# (relative to the player)
			var blood = Blood.instance()
			var drop_frame = 9
			var blood_position = Vector2(-5, -8)
		
			if $AnimatedSprite.animation == anim_act && $AnimatedSprite.frame == drop_frame:
				get_parent().get_parent().add_child(blood)
				blood.global_position = global_position - blood_position
		
	# Komainu effect
		KOMA_UM, KOMA_A:
			# Change UM and A state when pressed
			# and vise versa
			if Input.is_action_just_pressed("key_action"):
				state = KOMA_UM if state == KOMA_A else KOMA_A
				animation_tree()
	# Sick effect
		SICK:
			# Speed up
			speed = DEFAULT_SPEED + 100
			# Timer on being tired
			if action == NONE:
				$Run_Timer.start()
	
	# Broom effect
	if state == CLEAN:
		# Enable broom collision
		broomColis.disabled = false
	else:
		broomColis.disabled = true
	
	# Stun until action animation is finished
	if $AnimatedSprite.animation == anim_act && state != GOMI:
		stun_4anim(anim_act)


# Reload effect
func reloadEffect(effect:int):
	speed = DEFAULT_SPEED
	state = effect
	animation_tree()



"""
Timer control	
"""
# -> Default timer
func _on_Timer_timeout():
	stun = false
# -> Run timer
func _on_Run_Timer_timeout():
	if state == SICK:
		stun = true
		timer.set_wait_time(2)
		timer.start()
		$AnimatedSprite.animation = "sick_tired"
		$AnimatedSprite.play()
		action = ACT
		$Run_Timer.stop()


# Animation tree set
func animation_tree():
	# Normal
	if state == NORMAL:
		anim_L = "norm_L"
		anim_R = "norm_R"
		anim_U = "norm_U"
		anim_D = "norm_D"
		anim_act = "default"
	# Broom
	elif state == CLEAN:
		anim_L = "clean_L"
		anim_R = "clean_R"
		anim_U = "clean_U"
		anim_D = "clean_D"
		anim_act = "clean_happy"
	# Knife
	elif state == KNIFE:
		anim_L = "knife_L"
		anim_R = "knife_R"
		anim_U = "knife_U"
		anim_D = "knife_D"
		anim_act = "knife_cut"
	# Trash
	elif state == GOMI:
		anim_L = "gomi_L"
		anim_R = "gomi_R"
		anim_U = "gomi_U"
		anim_D = "gomi_D"
		anim_act = "gomi_hide"
	# Komainu
	elif state == KOMA_A:
		anim_L = "koma_a_L"
		anim_R = "koma_a_R"
		anim_U = "koma_U"
		anim_D = "koma_a_D"
		anim_act = "koma_close"
	elif state == KOMA_UM:
		anim_L = "koma_um_L"
		anim_R = "koma_um_R"
		anim_U = "koma_U"
		anim_D = "koma_um_D"
		anim_act = "koma_open"
	elif state == SICK:
		anim_L = "sick_L"
		anim_R = "sick_R"
		anim_U = "sick_U"
		anim_D = "sick_D"
		anim_act = "sick_act"

func debug():
	$StateDebug.show()
	$StunDebug.show()
	$EffectDebug.show()
	$AnimDebug.show()
	$VelocityDebug.show()
	
	$StateDebug.text = "ACT:" + str(action)
	$StunDebug.text = "STN:" + str(stun)
	$EffectDebug.text = "EFC: " + str(state)
	$AnimDebug.text = $AnimatedSprite.get_animation() + str($AnimatedSprite.frame) + "/" + str(get_animation_frames(get_curr_player_animation()))
	
	$TimerDebug.show() if state == SICK else $TimerDebug.hide()
	$TimerDebug.text = str($Run_Timer.get_time_left())

func get_action():
	return action

func get_state():
	return state

func get_curr_player_animation():
	return $AnimatedSprite.animation

func get_animation_frames(anim):
	return $AnimatedSprite.get_sprite_frames().get_frame_count(anim)
