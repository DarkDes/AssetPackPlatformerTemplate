class_name SettingsPanel
extends Panel

@onready var asset_name = $AssetName
@onready var assetpack_name_edit = $Grid/AssetpackNameEdit
@onready var nickname_edit = $Grid/NicknameEdit
@onready var sprites_lits = $SpritesLits

var asset_data = null 

func setup():
	asset_data = APM.current
	asset_name.text = asset_data.display_name;
	sprites_lits.clear();
	# По всем параметрам 
	for s in APM.sprite_def as Dictionary:
		sprites_lits.add_item(s)
	

func _on_save_pressed():
	asset_data


func _on_edit_asset_pack_pressed():
	visible = !visible
	if visible:
		setup()


func _on_sprites_lits_item_selected(index):
	pass # Replace with function body.
