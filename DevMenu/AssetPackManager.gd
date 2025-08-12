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
		"player": { "animations": [ "idle", "move", "jump", "fall", "action", ], "base_size": Vector2(32,32) },
		"coin": { "base_size": Vector2(16,16), },
		"enemy": { "animations": [ "move", "dying" ], "base_size": Vector2(32,32), },
		"danger": { "base_size": Vector2(32,16), },
		#"tileset": {},
		"platform_static": { "base_size": Vector2(48,16), },
		"platform_move": { "base_size": Vector2(48,16), },
		"flag": { "base_size": Vector2(32,32), },
		"background": { "base_size": Vector2(320,180), },
		"background_parallax": { "base_size": Vector2(320,180), },
		"decoration_small": { "base_size": Vector2(16,16), },
		"decoration_mid": { "base_size": Vector2(32,32), },
		"decoration_big": { "base_size": Vector2(48,48), },
		"ui_live": { "base_size": Vector2(16,16), },
		"ui_coin": { "base_size": Vector2(16,16), },
	}

var sprites : Dictionary = {} # [SpriteFramesAsset]
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
	var _pixelart 		= current.get_setting("pixel_art", false, false)
	var _spritescale 	= current.get_setting("sprite_scale", 1, false)
	for sprite_name in sprites:
		sprites[sprite_name].pixelated 		= _pixelart
		sprites[sprite_name].sprite_scale 	= _spritescale
		
	for tilemap in tilemaps:
		if _pixelart:
			tilemap.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		else:
			tilemap.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
