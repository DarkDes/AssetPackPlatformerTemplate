class_name Node2DSnapping
extends Node2D

@export var snapping_setting : SnappingSetting = preload("res://Game/snapping.tres")
var sprite : Node2D = null

func _ready():
	sprite = get_child(0) as Node2D

func _process(delta):
	#super._process(delta)
	sprite.global_position = snapping_setting.snap(global_position)
