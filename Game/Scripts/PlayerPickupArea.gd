extends Area2D

signal picked_up

@onready var parent_player := get_parent()

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.is_in_group("coin"):
		if "pick_up" in area:
			if area.pick_up(self):
				picked_up.emit(self, area)
		GD.coins += 1
		area.queue_free()
		
