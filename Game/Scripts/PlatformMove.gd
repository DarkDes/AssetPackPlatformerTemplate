## https://kidscancode.org/godot_recipes/4.x/2d/moving_platforms/index.html
class_name PlatformMove
extends Node2D

@export var offset = Vector2(0, -320)
@export var duration = 5.0
@onready var platform = $Platform

func _ready():
	start_tween()

func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(platform, "position", offset, duration / 2)
	tween.tween_property(platform, "position", Vector2.ZERO, duration / 2)

