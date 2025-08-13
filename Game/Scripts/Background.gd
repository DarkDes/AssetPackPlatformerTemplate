extends Node2D

@export var camera : Camera2D = null
@export var factor : float = 0
@export var snapping := Vector2(320*3, 180*3)

func _ready():
	pass
	
func _physics_process(delta):
	if camera:
		var _cam_pos = camera.global_position
		var _glob_pos = global_position
		var _child = get_child(0) as Node2D 
		_child.global_position = lerp(_cam_pos, Vector2.ZERO, factor)
		_child.global_position.snapped(snapping)
