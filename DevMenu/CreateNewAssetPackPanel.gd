extends Panel
@onready var asset_name = $AssetName
@onready var nickname_edit = $Grid/NicknameEdit
@onready var assetpack_name_edit = $Grid/AssetpackNameEdit
@onready var create = $Create
@onready var cancel = $Cancel

@onready var dir_scaner = $"../DirScaner"
@onready var dev_menu = $".."

func _ready():
	cancel.pressed.connect(
		func():
			visible = false
			get_tree().paused = false
	)
	create.pressed.connect(
		func():
			visible = false
			get_tree().paused = false
			dir_scaner.make_asset_directory(nickname_edit.text, assetpack_name_edit.text)
			dev_menu.rescan_and_build_selector()
			dev_menu.select_asset_pack(assetpack_name_edit.text)
	)
