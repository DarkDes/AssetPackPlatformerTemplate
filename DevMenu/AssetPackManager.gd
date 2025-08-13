class_name AssetPackManager
extends Node

signal asset_changed

var current : AssetPackData = null :
	set(value):
		current = value
		asset_changed.emit(value)
		apply_assetpack(current)
		# apply_to_all()

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


## 
## Найти, загрузить и применить спрайты
## 
func apply_assetpack(assetpack_data):
	# SPRITES
	for sprite_key in APM.sprite_def as Dictionary:
		apply_sprite_from_assetpack(sprite_key, APM.sprite_def[sprite_key], assetpack_data)
	
	# TILEMAP
	var tileset_path = assetpack_data.path.path_join("tilemap_0.png")
	if FileAccess.file_exists(tileset_path):
		var _image = Image.load_from_file(tileset_path)
		var _texture = ImageTexture.create_from_image(_image)
		for tileset in APM.tilesets:
			var _tile_source_id = tileset.get_source_id(0)
			var _tile_source = tileset.get_source(_tile_source_id)
			var _tile_atlas = _tile_source as TileSetAtlasSource
			if tileset is TileSetAsset:
				if tileset.pixel_size == 3 and _image.get_size() == Vector2i(80,80):
					_image.resize(80*3, 80*3, Image.INTERPOLATE_NEAREST)
					_texture = ImageTexture.create_from_image(_image)
			_tile_atlas.texture = _texture
	else:
	# DEFAULT
		for tileset in APM.tilesets:
			var _tile_source_id = tileset.get_source_id(0)
			var _tile_source = tileset.get_source(_tile_source_id)
			var _tile_atlas = _tile_source as TileSetAtlasSource
			_tile_atlas.texture = tileset.texture_default


func apply_sprite_from_assetpack(sprite_name, sprite_data, assetpack_data):
	var sframes : SpriteFramesAsset = APM.get_sprite(sprite_name)

	for anim in sframes.get_animation_names():
		var sprite_path = sprite_name + "_"
		if "animations" in sprite_data: 
			sprite_path += anim + "_"
		sprite_path = assetpack_data.path.path_join(sprite_path)
		
		print("Apply Asset: Looking for " + sprite_name + " " + anim ) # + " in " + sprite_path + "...")
		
		var frames_count = 0
		while(FileAccess.file_exists(sprite_path + str(frames_count) + ".png")): frames_count += 1
		# NO FRAMES FOUND -- DEFAULT SPRITE
		if frames_count == 0:
			push_error("Apply Asset: Sprites not found!")
			sframes.default_animation(anim)
		else:
		# LOAD FRAMES TO SPRITE
			print("Apply Asset: Found " + str(frames_count) + " of " + sprite_path)
			
			var fps = assetpack_data.get_setting("sprites_" + sprite_name + "_" + anim + "_fps", 
				assetpack_data.get_setting("default_fps", 5))
			sframes.set_animation_speed(anim, fps)
			
			sframes.clear(anim);
			for i in frames_count:
				var _path = sprite_path + str(i) + ".png"
				var _image = Image.load_from_file(_path)
				var _texture = ImageTexture.create_from_image(_image)
				#var _size = _image.get_size()
				#var _def_size = APM.sprite_def[sprite_name]["base_size"]
				#sframes.sprite_scale = 3 * (_def_size.x / _size.x) # ex. 32, 96
				#push_warning(_path, _image, _texture)
				sframes.add_frame(anim, _texture)
			sframes.send_updated()
	sframes.pixelated = assetpack_data.get_setting("pixel_art", false, false)
	sframes.sprite_scale = assetpack_data.get_setting("sprite_scale", 1, false) # ex. 32, 96
