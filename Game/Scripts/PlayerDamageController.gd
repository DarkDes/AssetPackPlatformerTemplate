extends Node

func _ready():
	get_parent().damaged.connect(_on_take_damage)
	
func _on_take_damage():
	# GameOver
	print("Damage")
	get_parent().velocity = -get_parent().velocity.limit_length(10)
	pass
