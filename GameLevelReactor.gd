# Контролирует финиш на уровне
extends Node

@onready var level_master = $"../LevelMaster"

func _ready():
	GD.level_finished.connect(_on_level_finished)
	GD.level_restarted.connect(_on_level_restarted)

func _on_level_finished():
	get_tree().paused = true
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	level_master.next_level()

func _on_level_restarted():
	get_tree().paused = true
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	level_master.restart_level()

func _on_level_master_level_changed():
	pass # Replace with function body.


func _on_level_master_levels_end():
	# Если закончился список уровней,
	# То тогда сменим ассет пак
	var _index = APM.assets_data.find(APM.current)
	_index = fmod(_index + 1, APM.assets_data.size())
	APM.current = APM.assets_data[_index]
	
	# И вернёмся к первому уровню
	level_master.level_index = 0
	level_master.load_level()
	
