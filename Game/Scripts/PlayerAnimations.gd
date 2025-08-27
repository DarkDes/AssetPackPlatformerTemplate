extends Node

@onready var character := get_parent()
@export var sprite: AnimatedSprite2D = null

@export var state : String = "movement"

func _process(delta):
	if sprite == null: return
	if sprite.sprite_frames == null: return
	
	if state == "movement":
		_animation_movement(character.velocity)

func do_action_one(after_finished : Callable):
	state = "action"
	sprite.play("action")
	#var sframes := animation_controller.sprite.sprite_frames as SpriteFrames
	#if sframes.get_frame_count("action") > 1:
	# await get_tree().create_timer(1.0).timeout
	await sprite.animation_finished
	state = "movement"
	after_finished.call()
	
func _animation_movement(movement):
	# Контроль анимации
	if movement.x > 0:
		sprite.set_flip_h(false)
	elif movement.x < 0:
		sprite.set_flip_h(true)
	
	if movement.y > 0:
		if sprite.sprite_frames.has_animation("fall"):
			sprite.play("fall")
	elif movement.y < 0:
		if sprite.sprite_frames.has_animation("jump"):
			sprite.play("jump")
	else:
		if movement.x != 0:
			if sprite.sprite_frames.has_animation("move"):
				sprite.play("move")
		else:
			if sprite.sprite_frames.has_animation("idle"):
				sprite.play("idle")
