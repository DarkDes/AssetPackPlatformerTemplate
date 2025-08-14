class_name Enemy
extends CharacterBody2D # PlayerPlatformer

signal damaged

@export var health = 1

@export var speed = 60
@export var run_speed = 90
@export var jump_speed = -350

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # @export var gravity = 400
@export_range(0.0, 1.0) var friction = 0.25
@export_range(0.0 , 1.0) var acceleration = 0.25

@onready var hitbox = $Hitbox
@onready var head_hitbox = $HeadHitbox

const ENEMY_DYING = preload("res://Game/enemy_dying.tscn")

# https://kidscancode.org/godot_recipes/4.x/2d/coyote_time/index.html
var coyote_time = 0.1
var coyote = false
var last_floor = false
var jumping = false
var grounded_speed = 0

var logic_enabled = true
var last_velocity : = Vector2.ZERO
var input_side_axis : float = 1
var input_jump = false

func _ready():
	head_hitbox.body_entered.connect(_on_head_hit)

# А можно было бы взять всё с CharacterPlatformer
# https://kidscancode.org/godot_recipes/4.x/2d/platform_character/index.html
func _physics_process(delta):
	if logic_enabled == false:
		return
		
	# Input, move and gravity
	velocity.y += gravity * delta
	
	var _speed = run_speed if false and is_on_floor() else speed
	if is_on_floor(): grounded_speed = _speed
	if input_side_axis != 0:
		velocity.x = lerp(velocity.x, input_side_axis * grounded_speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	
	# Jump
	if input_jump and (is_on_floor() or coyote) and jumping == false:
		velocity.y = jump_speed
		jumping = true

	# Двигай и сталкивай
	move_and_slide()
	
	# Coyot time
	if is_on_floor() and jumping:
		jumping = false
	
	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		# $CoyoteTimer.start()
	last_floor = is_on_floor()
	last_velocity = velocity
	
	# Hitbox
	var areas = hitbox.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("danger"):
			take_damage()


func take_damage():
	health -= 1
	if health <= 0:
		var _node = ENEMY_DYING.instantiate()
		get_parent().add_child(_node)
		_node.global_position = global_position
		queue_free()
		print("Enemy dead")
		return
	damaged.emit()
	print("Enemy damage")
	
func _on_head_hit(body):
	if body.is_in_group("player") and body.velocity.y > -0.1:
		take_damage()
		body.velocity.y = -300

#func die():
	#Global.instance_destroy(self)
	#var die = Global.spawn_load("res://Scenes/Enemy_Die.tscn", global_position) as Node2D
	#die.get_node("Pivot/Sprite").sprite_frames = $CollisionShape2D/AnimatedSprite2D.sprite_frames


func _on_visible_on_screen_notifier_2d_screen_entered():
	logic_enabled = true
