##
## BASED ON GODOT-10-GAMES: PLATFORMER
##
class_name PlayerPlatformer
extends CharacterBody2D

signal damaged

@export var speed = 120
@export var run_speed = 240
@export var jump_speed = -450

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # @export var gravity = 400
@export_range(0.0, 1.0) var friction = 0.25
@export_range(0.0 , 1.0) var acceleration = 0.35
# @export var controller : PlayerController = null

# https://kidscancode.org/godot_recipes/4.x/2d/coyote_time/index.html
var coyote_time := 0.1
var coyote := false
var last_floor := false
var jumping := false
var grounded_speed: float = 0
var coyote_timer : Timer = null

func _ready():
	coyote_timer = Timer.new()
	coyote_timer.wait_time = coyote_time
	coyote_timer.timeout.connect(func(): coyote = false)
	add_child(coyote_timer)
	
# https://kidscancode.org/godot_recipes/4.x/2d/platform_character/index.html
func _physics_process(delta):
	# Input, move and gravity
	var input_axis_move = Input.get_axis("move_left", "move_right") # controller.get_input_side()
	var input_jump = Input.is_action_pressed("jump") # controller.get_input_jump()
	var input_sprint = false
	
	velocity.y += gravity * delta
	
	var _speed = run_speed if input_sprint and is_on_floor() else speed
	if is_on_floor(): grounded_speed = _speed
	if input_axis_move != 0:
		velocity.x = lerp(velocity.x, input_axis_move * grounded_speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	
	# Jumping
	if input_jump and (is_on_floor() or coyote) and jumping == false:
		do_jump()
	elif jumping:
		# Fall
		velocity.y += gravity * 2.0 * delta

	# Двигай и сталкивай
	move_and_slide()
		
	# Coyot time
	if is_on_floor() and jumping:
		jumping = false
	
	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		coyote_timer.start()

	# Dust
	if last_floor != is_on_floor() and is_on_floor():
		var c = get_last_slide_collision()
		# SFX.play_player_landed()
		# Global.spawn_load("res://Scenes/fx_dust.tscn", c.get_position())
	last_floor = is_on_floor()


func do_jump():
	velocity.y = jump_speed
	jumping = true

