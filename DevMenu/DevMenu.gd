extends Control

@onready var dev_tool_button := $DevTool
@onready var dev_tool_panel = $DevToolPanel
@onready var asset_pack_selector = $DevToolPanel/AssetPackCon/AssetPackSelector
@onready var settings_panel = $DevToolPanel/SettingsPanel


@onready var dir_scaner = $DirScaner

const PLAYER_IDLE_0 = preload("res://Sprites/player_idle_0.png")

func _ready():
	dev_tool_panel.visible = false;
	dev_tool_button.visible = true;
	settings_panel.visible = false;
	
	dir_scaner.scan_asset_directory();
	var index = 0;
	for n in APM.assets_data:
		n.index = index
		asset_pack_selector.add_item(n.display_name, index)
		asset_pack_selector.set_item_metadata(index, n)
		index += 1
	
	# Выбрать самый первый ассет пак
	if index > 0:
		var asset_data = asset_pack_selector.get_item_metadata(0)
		APM.current = asset_data;
		apply_assetpack(asset_data)
	else:
		push_error("DEV MENU: NO ASSETS")
		
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

func apply_assetpack(assetpack_data):
	var sprites_dict = APM.sprite_def as Dictionary
	for sprite_key in sprites_dict:
		apply_sprite_from_assetpack(sprite_key, sprites_dict[sprite_key], assetpack_data)
		# print(sprite_key + " >> " + str(sprites_dict[sprite_key]))
	
func apply_sprite_from_assetpack(sprite_name, sprite_data, assetpack_data):
	var animated_sprite_2d = APM.get_sprite(sprite_name) # $"../../Player"
	if animated_sprite_2d == null:
		print("apply_sprite_from_assetpack: Cant find sprite with name " + sprite_name )
		return
	
	# animated_sprite_2d.texture_filter = TEXTURE_FILTER_NEAREST
	var sframes : SpriteFrames = animated_sprite_2d.sprite_frames
	var anims = sframes.get_animation_names()
	print(anims)
	for anim in anims:
		var sprite_path = sprite_name + "_"
		if "animations" in sprite_data: 
			sprite_path += anim + "_"
		sprite_path = assetpack_data.path.path_join(sprite_path)
		
		print("Apply Asset: Looking for " + sprite_name + " in " + sprite_path + "...")
		
		var frames_count = 0
		while(FileAccess.file_exists(sprite_path + str(frames_count) + ".png")): frames_count += 1
		if frames_count == 0:
			push_error("Apply Asset: Sprites not found!")
			# Need set default
			sframes.clear(anim);
			for i in 5:
				sframes.add_frame(anim,PLAYER_IDLE_0)
			return
		else:
			print("Apply Asset: Found " + str(frames_count) + " of " + sprite_path)
		
		#sframes.set_animation_speed(anim, assetpack_data.)
		var max_size = Vector2(1,1)
		sframes.clear(anim);
		for i in frames_count:
			var _path = sprite_path + str(i) + ".png"
			var _image = Image.load_from_file(_path)
			var _texture = ImageTexture.create_from_image(_image)
			
			max_size.x = max(max_size.x, _image.get_size().x)
			max_size.y = max(max_size.y, _image.get_size().y)
			
			push_warning(_path, _image, _texture)
			sframes.add_frame(anim, _texture)
		
		animated_sprite_2d.scale = Vector2(32,32)/max_size
		
		# print(anim + " >> " + str(frames_count))
	# animated_sprite_2d.play("idle")
		#for i in sframes.get_frame_count(anim):
			# var _path = assetpack_data.path + str(i+1) +".png"# "#OS.get_executable_path().get_base_dir().path_join("robot/s_robot_char_idle" + str(i) +".png")
			# var _image = Image.load_from_file(_path)
			# var _texture = ImageTexture.create_from_image(_image)
			# s.set_frame("default", i, _texture, _duration);
			
