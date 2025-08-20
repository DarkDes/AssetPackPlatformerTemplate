class_name SettingsPanel
extends Panel

const K_SPRITES = "sprites"
const K_ANIMATIONS = "animations"
const K_FPS = "fps"

@onready var asset_pack_selector = $"../AssetPackCon/AssetPackSelector"
@onready var add_new_asset_pack = $"../AddNewAssetPack"


@onready var asset_name = $AssetName
@onready var assetpack_name_edit = $Grid/AssetpackNameEdit
@onready var nickname_edit = $Grid/NicknameEdit
@onready var sprites_list = $Sprites/SpritesList
@onready var animations_list = $Anims/AnimationsList


@onready var pixel_art : CheckBox = $Main/PixelArt
@onready var ui_lives_selector : OptionButton = $Main/UILives/Selector
@onready var ui_coins_selector : OptionButton = $Main/UICoins/Selector
@onready var deafult_fps_spin = $Main/DefaultFPS/FPSSpin
@onready var scale_spin = $Main/SpriteScale/ScaleSpin

@onready var fps_spin = $AnimData/FPS/FPSSpin
@onready var delete_button = $AnimData/Delete

var asset_data : AssetPackData = null 
var sprite_selected_name = null
var animation_selected_name = null

var ignore_change_fps = false

func setup():
	asset_data = APM.current
	asset_name.text = asset_data.display_name;
	APM.asset_changed.connect(_asset_changed)

	# Name
	assetpack_name_edit.text = asset_data.display_name;
	nickname_edit.text = asset_data.author_name;
	assetpack_name_edit.connect("text_changed",
		func(): asset_data.settings_data.assetpack_name = assetpack_name_edit.text )
	nickname_edit.connect("text_changed",
		func(): asset_data.settings_data.author_name = nickname_edit.text )
	
	# Main
	pixel_art.button_pressed = asset_data.get_setting("pixel_art", false)
	ui_lives_selector.text = asset_data.get_setting("ui_lives_method", "NUMBERS")
	ui_coins_selector.text = asset_data.get_setting("ui_coins_method", "NUMBERS")
	deafult_fps_spin.value = asset_data.get_setting("default_fps", 5)
	scale_spin.value = asset_data.get_setting("sprite_scale", 1)
	
	pixel_art.toggled.connect(
		func(toggled_on):
			asset_data.set_setting("pixel_art", toggled_on)
			APM.apply_to_all()
			APM.ui_setting_changed.emit()
	)
	ui_lives_selector.item_selected.connect(
		func(index):
			asset_data.set_setting("ui_lives_method", ui_lives_selector.get_item_text(index))
			APM.ui_setting_changed.emit()
			)
	ui_coins_selector.item_selected.connect(
		func(index):
			asset_data.set_setting("ui_coins_method", ui_coins_selector.get_item_text(index))
			APM.ui_setting_changed.emit()
			)
	deafult_fps_spin.value_changed.connect(
		func(value):
			asset_data.set_setting("default_fps", value)
			APM.apply_to_sprites_default_fps(value)
			)
	
	scale_spin.value_changed.connect(
		func(value):
			asset_data.set_setting("sprite_scale", value)
			APM.apply_to_all()
			APM.ui_setting_changed.emit()
	)
	
	# По всем спрайтам
	sprites_list.clear();
	for s in APM.sprite_def as Dictionary:
		sprites_list.add_item(s)
	
	delete_button.disabled = true
	delete_button.pressed.connect( _on_delete_button_pressed )
		
	# Выделить начальный спрайт и анимацию
	sprites_list.select(0)
	_on_sprites_lits_item_selected(0)
	animations_list.select(0)
	_on_animations_list_item_selected(0)

func _asset_changed(asset):
	asset_name.text = asset_data.display_name;

	# Name
	assetpack_name_edit.text = asset_data.display_name;
	nickname_edit.text = asset_data.author_name;

	# Main
	pixel_art.button_pressed = asset_data.get_setting("pixel_art", false)
	ui_lives_selector.text = asset_data.get_setting("ui_lives_method", "NUMBERS")
	ui_coins_selector.text = asset_data.get_setting("ui_coins_method", "NUMBERS")
	deafult_fps_spin.value = asset_data.get_setting("default_fps", 5)
	scale_spin.value = asset_data.get_setting("sprite_scale", 1)
	
	APM.ui_setting_changed.emit()
	

func _on_save_pressed():
	var data_string = JSON.stringify(asset_data.settings_data, "\t") 
	var file = FileAccess.open(asset_data.path.path_join(DirScaner.SETTINGS_FILE), FileAccess.WRITE)
	file.store_string(data_string)
	file.close()
	
	# Использовать новые настройки
	# asset_data.settings_data.

func _on_reload_pressed():
	var settings_path = asset_data.path.path_join(DirScaner.SETTINGS_FILE)
	asset_data.settings_data = DirScaner.read_json_file(settings_path)
	# Гарантировать наличие настроек
	if asset_data.settings_data == null: asset_data.settings_data = {}

	# Find Display Name
	if asset_data.settings_data != null:
		if "author" in asset_data.settings_data:
			asset_data.author_name = asset_data.settings_data.author
		if "assetpack_name" in asset_data.settings_data:
			asset_data.display_name = asset_data.settings_data.assetpack_name
	
	APM.apply_to_sprites_default_fps(asset_data.get_setting("default_fps", 5, false))
	APM.apply_to_all()
	APM.ui_setting_changed.emit()
	_asset_changed(APM.current)

func _on_edit_asset_pack_pressed():
	visible = !visible
	if visible:
		setup()
	asset_pack_selector.disabled = visible
	add_new_asset_pack.disabled = visible

func _on_delete_button_pressed():
	asset_data.settings_data.erase(get_current_sprite_animation_key(K_FPS))
	fps_spin.value = asset_data.get_setting("default_fps", 5)
	ignore_change_fps = true
	delete_button.disabled = true

func sprite_animation_selected():
	# Заполнить данные
	fps_spin.value = asset_data.get_setting("default_fps", 5);
	var key = get_current_sprite_animation_key(K_FPS)
	if key in asset_data.settings_data:
		fps_spin.value = asset_data.settings_data[key]
		delete_button.disabled = false
	else:
		delete_button.disabled = true
	ignore_change_fps = true

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
	_on_animations_list_item_selected(0)

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

func get_current_sprite_animation_key(add = ""):
	return "%s_%s_%s_%s" % [K_SPRITES, sprite_selected_name, animation_selected_name, add]

func _on_fps_spin_value_changed(value):
	#var _config = get_sprite_data_for_changes(sprite_selected_name)
	#if (animation_selected_name in _config) == false:
		#_config[animation_selected_name] = {}
	#_config[animation_selected_name][K_FPS] = value
	if ignore_change_fps == false:
		asset_data.set_setting(get_current_sprite_animation_key(K_FPS), value)
		APM.get_sprite(sprite_selected_name).set_animation_speed(animation_selected_name, value)
	
	ignore_change_fps = false
	delete_button.disabled = false
	# Apply FPS to Anim
	
func get_sprite_data_for_changes(sprite_name):
	if (K_SPRITES in asset_data.settings_data) == false:
		asset_data.settings_data[K_SPRITES] = {}
	var _sprites = asset_data.settings_data[K_SPRITES]
	if (sprite_name in _sprites) == false:
		_sprites[sprite_name] = {}
	var _config = _sprites[sprite_name]
	return _config


