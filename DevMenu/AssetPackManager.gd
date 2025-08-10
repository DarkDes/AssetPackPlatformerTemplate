class_name AssetPackManager
extends Node

var current : AssetPackData = null

@export var assets_data : Array[AssetPackData] = []
@export var sprite_def  = {
		"player": { "animations": [ "idle", "move", "jump", "fall", "action", ] },
		"coin": {},
		"enemy": { "animations": [ "move", "dying" ] },
		"danger": {},
		#"tileset": {},
		"platform_static": {},
		"platform_move": {},
		"flag": {},
		"background": {},
		"background_parallax": {},
		"decoration_small": {},
		"decortaion_mid": {},
		"decoration_big": {},
		"ui_live": {},
		"ui_coin": {},
	}

var sprites : Dictionary = {}

func add_sprite(sprite_name, sprite_node):
	if sprite_name in sprites:
		# Already here, send changes based on data
		sprites[sprite_name] = sprite_node;
	else:
		sprites[sprite_name] = sprite_node;
	print( "APM > Sprite set " + sprite_name );
	
func get_sprite(sprite_name):
	if sprites.has(sprite_name):
		return sprites[sprite_name]
	return null
