extends Node2D

@export var delete_on_animation_finished := false

@onready var sprite = $Node2DSnapping/Enemy

func _ready():
	await get_tree().process_frame
	sprite.play("dying")
	if delete_on_animation_finished:
		sprite.animation_finished.connect(func():queue_free())
