extends KinematicBody2D

export (PackedScene) var Blood
onready var plr = get_node("/root/PlayerStats")

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

# Screen size
var screen_size

# Timer
onready var timer = get_node("Timer")
var timer_run = false

# Collision
onready var broomColis = get_node("Broom/Broom_Collision")

# When loading a node prepare animation tree
# and get screen size
func _ready():
	plr.animation_tree()
	$AnimatedSprite.play()
	screen_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))

# Running every frame
func _process(delta):
	var velocity = input()
	#debug()
	effects()

	# If colliding change animation
	if move_and_collide(velocity * delta):
		stop_anim(1)
	plr.position = position

	# Restrict to screen size
	#restrict_to_screen()
	
	animate(velocity)

"""
Input & control
"""
# Function that describes input
# Returns: Vector2D velocity
func input():

	var velocity = Vector2()

	# Movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = input_vector.normalized()
	
	# Action
	if Input.is_action_just_pressed("key_action"):
		velocity = Vector2(0, 0)
		plr.action = plr.ACT
		$AnimatedSprite.animation = plr.anim_act
		$AnimatedSprite.play()
		

	# Get velocity from input if not stunned
	if !plr.stun:
		pass
	else:
		velocity = Vector2(0, 0)

	# Play animation when moving, stop on frame 1
	# when standing, set current action
	if velocity.length() > 0:
		plr.action = plr.WALK
		velocity = velocity.normalized() * plr.speed
		$AnimatedSprite.play()
	elif velocity.length() <= 0 && plr.action != plr.ACT:
		plr.action = plr.NONE
		stop_anim(1)
	
	$VelocityDebug.text = str(velocity)
	
	plr.change_effect()
	
	return velocity

# Stun for time
func stun_for(time):
	timer.set_wait_time(time)
	timer.start()
	plr.stun = true

# Stop animation on certain frame
func stop_anim(frame):
	$AnimatedSprite.frame = frame
	$AnimatedSprite.stop()

# Stun until the end of animation
func stun_4anim(anim):
	var num_frames = get_animation_frames(anim)
	if $AnimatedSprite.frame < num_frames - 1:
		plr.stun = true
	else:
		plr.stun = false

# Toggle stun plr.state
func stunToggle():
	plr.stun = not plr.stun

# Sets animations to actions
func animate(velocity):
	if velocity.x > 0:
		$AnimatedSprite.animation = plr.anim_R
	elif velocity.x < 0:
		$AnimatedSprite.animation = plr.anim_L
	elif velocity.y < 0:
		$AnimatedSprite.animation = plr.anim_U
	elif velocity.y > 0:
		$AnimatedSprite.animation = plr.anim_D

# Restricts player movement to screen
func restrict_to_screen():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

"""
Effects
"""
# Effect-specific actions
func effects():
	
	match plr.state:
	# Trash effect
		GOMI:	
			# Stun on action
			if Input.is_action_just_pressed("key_action"):
				stunToggle()
				# Unstun in second action
				# Play unhide animation
				if !plr.stun:
					plr.anim_act = "gomi_unhide"
					$AnimatedSprite.animation = plr.anim_act
					$AnimatedSprite.play()
					plr.animation_tree()
		
	# Knife effect
		KNIFE:
			# Spawn blood on drop_frame frame
			# on blood_position point
			# (relative to the player)
			var blood = Blood.instance()
			var drop_frame = 9
			var blood_position = Vector2(-5, -8)
		
			if $AnimatedSprite.animation == plr.anim_act && $AnimatedSprite.frame == drop_frame:
				get_parent().get_parent().add_child(blood)
				blood.global_position = global_position - blood_position
		
	# Komainu effect
		KOMA_UM, KOMA_A:
			# Change UM and A plr.state when pressed
			# and vise versa
			if Input.is_action_just_pressed("key_action"):
				plr.state = KOMA_UM if plr.state == KOMA_A else KOMA_A
				plr.animation_tree()
	# Sick effect
		SICK:
			# Speed up
			plr.speed = plr.DEFAULT_SPEED + 100
			# Timer on being tired
			if plr.action == plr.NONE:
				$Run_Timer.start()
	
	# Broom effect
	if plr.state == CLEAN:
		# Enable broom collision
		broomColis.disabled = false
	else:
		broomColis.disabled = true
	
	# Stun until action animation is finished
	if $AnimatedSprite.animation == plr.anim_act && plr.state != GOMI:
		stun_4anim(plr.anim_act)


"""
Timer control	
"""
# -> Default timer
func _on_Timer_timeout():
	plr.stun = false

# -> Run timer
func _on_Run_Timer_timeout():
	if plr.state == SICK:
		plr.stun = true
		stun_for(2)
		$AnimatedSprite.animation = "sick_tired"
		$AnimatedSprite.play()
		plr.action = plr.ACT
		$Run_Timer.stop()

func debug():
	$StateDebug.show()
	$StunDebug.show()
	$EffectDebug.show()
	$AnimDebug.show()
	$VelocityDebug.show()
	
	$StateDebug.text = "ACT:" + str(plr.action)
	$StunDebug.text = "STN:" + str(plr.stun)
	$EffectDebug.text = "EFC: " + str(plr.state)
	$AnimDebug.text = $AnimatedSprite.get_animation() + str($AnimatedSprite.frame) + "/" + str(get_animation_frames(get_curr_player_animation()))
	
	$TimerDebug.show() if plr.state == SICK else $TimerDebug.hide()
	$TimerDebug.text = str($Timer.get_time_left())

func get_action():
	return plr.action

func get_curr_player_animation():
	return $AnimatedSprite.animation

func get_animation_frames(anim):
	return $AnimatedSprite.get_sprite_frames().get_frame_count(anim)
