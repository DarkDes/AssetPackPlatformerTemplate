class_name PlayerPlatformerX3
extends PlayerPlatformer
@onready var player_sprite = $PlayerSprite

var snapping = true

func _input(event):
	if Input.is_key_pressed(KEY_T):
		snapping = !snapping
		
func _process(delta):
	#super._process(delta)
	if snapping:
		var _pos = global_position
		_pos.x = snapped(_pos.x, 3)
		_pos.y = snapped(_pos.y, 3)
		player_sprite.global_position = _pos
	else:
		player_sprite.global_position = global_position
