## Based on Godot 10 Games - Platformer
class_name LevelMaster
extends Node2D

signal levels_end

@export var levels : Array[PackedScene] = []
@export var level_index = 0 :
	set(value):
		level_index = clamp(value, 0, levels.size()-1)

var current_level : WorldLevel = null

func _ready():
	load_level()

func next_level():
	if level_index == (levels.size()-1):
		levels_end.emit()
		return
	level_index += 1
	load_level()

func load_level():
	# Variant 0:
	current_level = get_child(0) as WorldLevel
	if current_level:
		print("Remove current")
		current_level.queue_free()
		#current_level.level_finished.disconnect(get_parent()._on_level_level_finished)
		remove_child(current_level)
		
	print("Load Level")
	current_level = levels[level_index].instantiate() as WorldLevel
	# current_level.level_finished.connect(get_parent()._on_level_level_finished)
	add_child(current_level)

func restart_level():
	load_level()
