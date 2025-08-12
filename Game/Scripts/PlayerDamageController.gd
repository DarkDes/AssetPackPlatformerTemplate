extends Node

@onready var damage_area = $"../DamageArea"

var character : CharacterBody2D = null
var ignore_damage = false

func _ready():
	character = get_parent() as CharacterBody2D
	
	if "damaged" in character:
		character.damaged.connect(_on_take_damage)
	
func _on_take_damage():
	# GameOver
	if ignore_damage:
		return
	print("Damage")
	character.velocity.x = -sign(character.velocity.x) * max(100, abs(character.velocity.x))
	character.velocity.y = -300
	
	GD.lives -= 1
	if GD.lives < 0:
		print("Game Over")
	
	ignore_damage = true
	await get_tree().create_timer(2.0).timeout
	ignore_damage = false


func _process(delta):
	var areas = damage_area.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("danger"):
			character.damaged.emit()
