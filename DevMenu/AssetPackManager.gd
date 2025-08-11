class_name AssetPackManager
extends Node

signal asset_changed

var current : AssetPackData = null :
	set(value):
		current = value
		asset_changed.emit(value)
		apply_to_all()

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
		"decoration_mid": {},
		"decoration_big": {},
		"ui_live": {},
		"ui_coin": {},
	}

var sprites : Dictionary = {}
var tilemaps : Array[TileMap] = []
var tilesets : Array[TileSetAsset] = []

func _ready():
	for sprite_name in sprite_def as Dictionary:
		var _sprite = load("res://Sprites/s_" + sprite_name + ".tres")
		sprites[sprite_name] = _sprite
	
	tilesets.append(load("res://Tilemap/tileset_0.tres"))
	tilesets.append(load("res://Tilemap/tileset_x3.tres"))
	
func add_sprite(sprite_name, sprite_node):
	pass
	
	#if sprite_name in sprites:
		## Already here, send changes based on data
		#sprites[sprite_name] = sprite_node;
	#else:
		#sprites[sprite_name] = sprite_node;
	#print( "APM > Sprite set " + sprite_name );
	
func get_sprite(sprite_name):
	if sprites.has(sprite_name):
		return sprites[sprite_name]
	return null

func add_tilemap(tilemap):
	tilemaps.append(tilemap)

func apply_to_all():
	var _pixelart = current.get_setting("pixel_art", false, false)
	for sprite in sprites:
		print(sprite)
		
	for tilemap in tilemaps:
		if _pixelart:
			tilemap.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		else:
			tilemap.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
