class_name SettingsPanel
extends Panel

@onready var asset_name = $AssetName
@onready var assetpack_name_edit = $Grid/AssetpackNameEdit
@onready var nickname_edit = $Grid/NicknameEdit
@onready var sprites_list = $Sprites/SpritesList
@onready var animations_list = $Anims/AnimationsList

@onready var pixel_art : CheckBox = $Main/PixelArt
@onready var ui_lives_selector : OptionButton = $Main/UILives/Selector
@onready var ui_coins_selector : OptionButton = $Main/UICoins/Selector

@onready var fps_spin = $AnimData/FPS/FPSSpin

var asset_data : AssetPackData = null 
var sprite_selected_name = null
var animation_selected_name = null

const K_SPRITES = "sprites"
const K_ANIMATIONS = "animations"
const K_FPS = "fps"

func setup():
	asset_data = APM.current
	asset_name.text = asset_data.display_name;
	
	# Name
	assetpack_name_edit.text = asset_data.display_name;
	nickname_edit.text = asset_data.author_name;
	assetpack_name_edit.connect("text_changed",
		func(): 
			asset_data.settings_data.assetpack_name = assetpack_name_edit.text
	)
	nickname_edit.connect("text_changed",
		func(): 
			asset_data.settings_data.author_name = nickname_edit.text
	)
	
	# Main
	pixel_art.button_pressed = asset_data.get_setting("pixel_art", false)
	ui_lives_selector.text = asset_data.get_setting("ui_lives_method", "NUMBERS")
	ui_coins_selector.text = asset_data.get_setting("ui_coins_method", "NUMBERS")

	# По всем спрайтам
	sprites_list.clear();
	for s in APM.sprite_def as Dictionary:
		sprites_list.add_item(s)
	
	
	# Выделить начальный спрайт и анимацию
	sprites_list.select(0)
	_on_sprites_lits_item_selected(0)
	animations_list.select(0)
	_on_animations_list_item_selected(0)
	

func _on_save_pressed():
	var data_string = JSON.stringify(asset_data.settings_data, "\t") 
	var file = FileAccess.open(asset_data.path.path_join("settings.json"), FileAccess.WRITE)
	file.store_string(data_string)
	file.close()
	
	# Использовать новые настройки
	# asset_data.settings_data.


func _on_edit_asset_pack_pressed():
	visible = !visible
	if visible:
		setup()

func sprite_animation_selected():
	# Заполнить данные
	fps_spin.value = 5 # default
	if K_SPRITES in asset_data.settings_data:
		var _sprites = asset_data.settings_data[K_SPRITES]
		if sprite_selected_name in _sprites:
			var _config = _sprites[sprite_selected_name]
			if animation_selected_name in _config:
				var _animdata = _config[animation_selected_name];
				fps_spin.value = _animdata[K_FPS]
				print("Settings: set FPS " + str(_animdata[K_FPS]));
			else:
				print("Settings: NO animation_selected_name in _config");
		else:
			print("Settings: NO sprite_selected_name in _sprites");
	else:
		print("Settings: NO sprites in asset_data.settings_data");

func _on_sprites_lits_item_selected(index):
	sprite_selected_name = sprites_list.get_item_text(index)
	var sprite_selected = APM.sprite_def[sprite_selected_name]
	animations_list.clear();
	if K_ANIMATIONS in sprite_selected:
		for anim in sprite_selected.animations:
			animations_list.add_item(anim)
	else:
		animations_list.add_item("idle")
	animations_list.select(0)
	

func _on_animations_list_item_selected(index):
	animation_selected_name = animations_list.get_item_text(index)
	
	# Заполнить данные
	sprite_animation_selected()
	
	## sprite_animation_selected = 
	#var def = APM.sprite_def[sprite_name]
	#if "animations" in def:
		#for anim in def.animations:
			#animations_list.add_item(anim)
	#else:
		#animations_list.add_item("idle")


func _on_fps_spin_value_changed(value):
	var _config = get_sprite_data_for_changes(sprite_selected_name)
	if (animation_selected_name in _config) == false:
		_config[animation_selected_name] = {}
	_config[animation_selected_name][K_FPS] = value
	
	# Apply FPS to Anim
	
func get_sprite_data_for_changes(sprite_name):
	if (K_SPRITES in asset_data.settings_data) == false:
		asset_data.settings_data[K_SPRITES] = {}
	var _sprites = asset_data.settings_data[K_SPRITES]
	if (sprite_name in _sprites) == false:
		_sprites[sprite_name] = {}
	var _config = _sprites[sprite_name]
	return _config

