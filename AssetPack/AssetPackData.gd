class_name AssetPackData
extends Resource

@export var display_name : String = "Asset pack";
@export var author_name : String = "No one";
@export var path : String = "";
@export var settings_data = {}; 

var index = -1 # Для списка

func get_assetpack_name() -> String:
	return author_name + " - " + display_name
