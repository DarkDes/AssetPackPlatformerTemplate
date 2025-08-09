class_name AssetPackManager
extends Node

@export var assets_data : Array[AssetPackData] = []

var sprites : Dictionary = {}

func add_sprite(sprite_name, sprite_node):
	sprites[sprite_name] = sprite_node;
	print( "APM > Sprite set " + sprite_name );
	
func get_sprite(sprite_name):
	if sprites.has(sprite_name):
		return sprites[sprite_name]
	return null
