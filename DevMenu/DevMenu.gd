extends Control

@onready var dev_tool_button := $DevTool
@onready var dev_tool_panel = $DevToolPanel
@onready var asset_pack_selector = $DevToolPanel/AssetPackCon/AssetPackSelector


@onready var dir_scaner = $DirScaner



func _ready():
	dev_tool_panel.visible = false;
	dev_tool_button.visible = true;
	
	dir_scaner.scan_asset_directory();
	var index = 1001;
	for n in dir_scaner.assets:
		asset_pack_selector.add_item(n.name, index)
		index += 1

func _on_dev_tool_pressed():
	dev_tool_panel.visible = true;
	dev_tool_button.visible = false;

func _on_dev_tool_close_pressed():
	dev_tool_panel.visible = false;
	dev_tool_button.visible = true;

func _on_asset_pack_selector_item_selected(index):
	change_assetpack()


func change_assetpack():
	OS.alert('change_assetpack', 'Message Title')
