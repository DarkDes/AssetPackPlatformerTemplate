class_name Node2DSnapping
extends Node2D

@export var snapping_pixels = 3
@export var snapping = true : 
	set(value):
		snapping = value
		if snapping == false:
			sprite.global_position = global_position
var sprite : Node2D = null

func _ready():
	sprite = get_child(0) as Node2D

func _input(event):
	if Input.is_key_pressed(KEY_T):
		snapping = !snapping
		
func _process(delta):
	#super._process(delta)
	if snapping:
		sprite.global_position = global_position.snapped(Vector2(snapping_pixels, snapping_pixels))
