class_name AssetPackData
extends Resource

@export var display_name : String = "Asset pack";
@export var author_name : String = "No one";
@export var path : String = "";
@export var settings_data = {}; 

var index = -1 # Для списка

func get_assetpack_name() -> String:
	return author_name + " - " + display_name
	
func get_setting(setting_name, default_value, create_if_no_exists=true):
	if create_if_no_exists:
		if (setting_name in settings_data) == false:
			settings_data[setting_name] = default_value;
		return settings_data[setting_name];
	#else
	if setting_name in settings_data:
		return settings_data[setting_name];
	return default_value
	
func set_setting(setting_name, value):
	settings_data[setting_name] = value
