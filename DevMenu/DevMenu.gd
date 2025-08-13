extends Control

@onready var dev_tool_button := $DevTool
@onready var dev_tool_panel = $DevToolPanel
@onready var asset_pack_selector = $DevToolPanel/AssetPackCon/AssetPackSelector
@onready var settings_panel = $DevToolPanel/SettingsPanel

@onready var create_new_asset_pack_panel = $CreateNewAssetPackPanel

@onready var dir_scaner = $DirScaner

var TILESET_ATLAS : AtlasTexture = preload("res://Tilemap/tileset_atlas.tres")

func _ready():
	dev_tool_panel.visible = false;
	dev_tool_button.visible = true;
	settings_panel.visible = false;
	create_new_asset_pack_panel.visible = false
	
	rescan_and_build_selector()
	select_first_asset_pack()

	
	
func rescan_and_build_selector():
	dir_scaner.scan_asset_directory();
	var index = 0;
	for n in APM.assets_data:
		n.index = index
		asset_pack_selector.add_item(n.display_name, index)
		asset_pack_selector.set_item_metadata(index, n)
		index += 1
	
func select_first_asset_pack():
	# Выбрать самый первый ассет пак
	if asset_pack_selector.item_count > 0:
		var asset_data = asset_pack_selector.get_item_metadata(0)
		APM.current = asset_data;
		apply_assetpack(asset_data)
	else:
		push_error("DEV MENU: NO ASSETS")

func select_asset_pack(name):
	for i in asset_pack_selector.item_count:
		if asset_pack_selector.get_item_text(i) == name:
			asset_pack_selector.select(i)
			return
	asset_pack_selector.select(0)


func _on_dev_tool_pressed():
	dev_tool_panel.visible = true;
	dev_tool_button.visible = false;

func _on_dev_tool_close_pressed():
	dev_tool_panel.visible = false;
	dev_tool_button.visible = true;

func _on_asset_pack_selector_item_selected(index):
	var asset_data = asset_pack_selector.get_item_metadata(index)
	APM.current = asset_data;
	apply_assetpack(asset_data)

## 
## 
## 
func apply_assetpack(assetpack_data):
	var sprites_dict = APM.sprite_def as Dictionary
	for sprite_key in sprites_dict:
		apply_sprite_from_assetpack(sprite_key, sprites_dict[sprite_key], assetpack_data)
		# print(sprite_key + " >> " + str(sprites_dict[sprite_key]))
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

		#TILESET_ATLAS.atlas = _texture
		#tilemap


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
		if frames_count == 0:
			push_error("Apply Asset: Sprites not found!")
			sframes.default_animation(anim)
		else:
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


func _on_add_new_asset_pack_pressed():
	create_new_asset_pack_panel.visible = true
	get_tree().paused = true
