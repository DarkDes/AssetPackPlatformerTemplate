extends Node

signal level_finished

@export var lives := 3
@export var coins := 0

func level_finish():
	print("Level Finshed, next")
	level_finished.emit()
	
