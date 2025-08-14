extends Node

signal level_finished
signal level_restarted

@export var lives := 3
@export var coins := 0 :
	set(value):
		coins = value
		if coins >= 20:
			coins = value - 20
			lives += 1

func level_finish():
	print("Level Finshed, next")
	level_finished.emit()
	
func level_restart():
	print("GD Level Restarting")
	lives = 1
	level_restarted.emit()
