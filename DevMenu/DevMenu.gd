extends Control

@onready var dev_tool_button := $DevTool
@onready var dev_tool_panel = $DevToolPanel
@onready var asset_pack_selector = $DevToolPanel/AssetPackCon/AssetPackSelector
@onready var settings_panel = $DevToolPanel/SettingsPanel

@onready var create_new_asset_pack_panel = $CreateNewAssetPackPanel

@onready var skip_intro = $DevToolPanel/SkipIntro


@onready var dir_scaner = $DirScaner

var TILESET_ATLAS : AtlasTexture = preload("res://Tilemap/tileset_atlas.tres")

func _ready():
	dev_tool_panel.visible = false;
	dev_tool_button.visible = true;
	settings_panel.visible = false;
	create_new_asset_pack_panel.visible = false
	
	rescan_and_build_selector()
	select_first_asset_pack()

func _gui_input(event):
	print(event)

func rescan_and_build_selector():
	dir_scaner.scan_asset_directory();
	
	asset_pack_selector.clear()
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


func _on_add_new_asset_pack_pressed():
	create_new_asset_pack_panel.visible = true
	get_tree().paused = true


