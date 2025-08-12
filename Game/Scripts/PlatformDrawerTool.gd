@tool
extends Node2D

@onready var parent = null 

func _ready():
	parent = get_parent() as PlatformMove
	if Engine.is_editor_hint() == false:
		visible = false
	
func _draw():
	if parent != null:
		draw_line(Vector2.ZERO, parent.offset, Color.RED, 10, true)

func _process(delta):
	queue_redraw()
	
