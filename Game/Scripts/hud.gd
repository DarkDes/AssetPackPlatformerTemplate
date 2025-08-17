extends Control

@onready var lives_label = $VBoxContainer/UILivesText/LivesLabel
@onready var coins_label = $VBoxContainer/UICoinsText/CoinsLabel

@onready var ui_lives_text = $VBoxContainer/UILivesText
@onready var ui_coins_text = $VBoxContainer/UICoinsText
@onready var ui_lives_counts = $VBoxContainer/UILivesCounts
@onready var ui_coins_counts = $VBoxContainer/UICoinsCounts

@export var lives_method = "NUMBERS" # "COUNTS"
@export var coins_method = "NUMBERS" # "COUNTS"


const PRESS_START_2P_REGULAR = preload("res://PressStart2P-Regular.ttf")
const ROBOTO_BLACK = preload("res://Roboto-Black.ttf")


func _ready():
	GD.stats_changed.connect(update_elements_display)
	APM.ui_setting_changed.connect(_on_change_method)
	
	await get_tree().process_frame
	_on_change_method()


func update_elements_display():
	if lives_method == "NUMBERS":
		lives_label.text = "x " + str(GD.lives)
	else:
		update_count(ui_lives_counts, GD.lives, "ui_live")
	
	if coins_method == "NUMBERS":
		coins_label.text = "x " + str(GD.coins)
	else:
		update_count(ui_coins_counts, GD.coins, "ui_coin")


func update_count(ui_element_counts : Control, new_count : int, sprite_element_name) -> void:
	
	var assetpack_data = APM.current
	var sprite_scale = assetpack_data.get_setting("sprite_scale", 1, false)
	
	for child in ui_element_counts.get_children():
		child.visible = false
	for i in new_count:
		if ui_element_counts.get_child(i):
			ui_element_counts.get_child(i).visible = true
			ui_element_counts.get_child(i).position.x = i * APM.sprite_def[sprite_element_name].base_size.x * sprite_scale
		else:
			var _new_node = ui_element_counts.get_child(0).duplicate()
			ui_element_counts.add_child(_new_node)
			_new_node.position.x = i * APM.sprite_def[sprite_element_name].base_size.x * sprite_scale
			_new_node.visible = true


func _on_change_method():
	var assetpack_data = APM.current
	var sprite_scale = assetpack_data.get_setting("sprite_scale", 1, false)
	var pixelated = assetpack_data.get_setting("pixel_art", true, false)
	
	lives_method = assetpack_data.get_setting("ui_lives_method","NUMBERS", false)
	update_ui_elements(lives_method, ui_lives_text, ui_lives_counts, lives_label, "ui_live")
	
	coins_method = assetpack_data.get_setting("ui_coins_method","NUMBERS", false)
	update_ui_elements(coins_method, ui_coins_text, ui_coins_counts, coins_label, "ui_coin")

	# Не совсем понятно как это должно работать
	if pixelated:
		var theme = ui_lives_text.theme as Theme
		theme.set_font("default_font", "Control", PRESS_START_2P_REGULAR)
	else:
		var theme = ui_lives_text.theme as Theme
		theme.set_font("default_font", "Control", ROBOTO_BLACK)
	print("UI changed")


func update_ui_elements(method, ui_elem_text, ui_elem_counts, ui_elem_label, sprite_element_name):
	var assetpack_data = APM.current
	var sprite_scale = assetpack_data.get_setting("sprite_scale", 1, false)
	# var pixelated = assetpack_data.get_setting("pixel_art", true, false)
	if method == "NUMBERS":
		ui_elem_text.visible = true
		ui_elem_counts.visible = false
		ui_elem_label.scale = Vector2(sprite_scale, sprite_scale)
	else:
		ui_elem_text.visible = false
		ui_elem_counts.visible = true
		
		for child_index in range(1, ui_elem_counts.get_child_count()):
			var child = ui_elem_counts.get_child(child_index)
			child.position.x = ui_elem_counts.get_child(0).position.x
			child.position.x += child_index * APM.sprite_def[sprite_element_name].base_size.x * sprite_scale
	update_elements_display()
