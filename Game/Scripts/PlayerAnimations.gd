extends Node

@onready var character := get_parent()
@export var sprite: AnimatedSprite2D = null

func _process(delta):
	if sprite == null: return
	if sprite.sprite_frames == null: return
	
	var movement = character.velocity
	
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
