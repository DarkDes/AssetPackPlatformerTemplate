class_name MobAI
extends Node

@onready var mob : Enemy = get_parent()

func _process(delta):
	if mob.is_on_wall():
		mob.input_side_axis = -mob.input_side_axis
