extends Node

signal level_finished
signal level_restarted

signal stats_changed

@export var lives := 3 :
	set(value):
		lives = value
		stats_changed.emit()
		
@export var coins := 0 :
	set(value):
		coins = value
		if coins >= 20:
			coins = value - 20
			lives += 1
		stats_changed.emit()

func level_finish():
	print("Level Finshed, next")
	level_finished.emit()
	
func level_restart():
	print("GD Level Restarting")
	if lives <= 0: lives = 0
	level_restarted.emit()
