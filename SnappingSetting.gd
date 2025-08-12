class_name SnappingSetting
extends Resource

signal unsnapped

@export var snapping_scale = 3
@export var snapping = true : 
	set(value):
		snapping = value
		if snapping == false:
			unsnapped.emit()

func snap(global_position : Vector2):
	if snapping and snapping_scale > 1:
		return global_position.snapped(Vector2(snapping_scale, snapping_scale))
	return global_position
