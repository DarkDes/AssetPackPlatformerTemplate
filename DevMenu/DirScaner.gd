extends Node

#var ASSET_DIR : String = "res://Assets"
var ASSET_DIR : String = OS.get_executable_path().get_base_dir().path_join("Assets")
const SETTINGS_FILE : String = "settings.json"

var authors_dirs = []

func _ready():
	if DirAccess.dir_exists_absolute(ASSET_DIR) == false:
		ASSET_DIR = "res://Assets"

func make_asset_directory(author, asset_name):
	var asset_path = ASSET_DIR.path_join(author).path_join(asset_name)
	DirAccess.make_dir_recursive_absolute(asset_path)
	var file = FileAccess.open(asset_path.path_join(SETTINGS_FILE), FileAccess.WRITE)
	file.store_string("{}")
	file.close()
	
	var data = AssetPackData.new()
	data.path 			= asset_path
	data.author_name	= author
	data.display_name	= asset_name
	data.settings_data  = {}
	
	# Add to Asset Master
	APM.assets_data.append( data )
	
## 
## 
## 
func scan_asset_directory():
	scan_authors()
	
	for author in authors_dirs:
		var author_path = ASSET_DIR.path_join(author)
		var dir_access = DirAccess.open(author_path)
		dir_access.list_dir_begin()
		
		# APM.assets_data.clear()
		
		var file_name: String = dir_access.get_next()
		while file_name != "":
			var settings_path = author_path.path_join(file_name).path_join(SETTINGS_FILE)
			if dir_access.current_is_dir() and FileAccess.file_exists(settings_path):
				
				var data 			= AssetPackData.new()
				data.path 			= author_path.path_join(file_name)
				data.author_name	= author
				data.display_name	= file_name
				data.settings_data  = read_json_file(settings_path);
				
				# Гарантировать наличие настроек
				if data.settings_data == null: data.settings_data = {}
			
				# Find Display Name
				if data.settings_data != null:
					if "author" in data.settings_data:
						data.author_name = data.settings_data.author
					if "assetpack_name" in data.settings_data:
						data.display_name = data.settings_data.assetpack_name
				
				# Add to Asset Master
				var _found = APM.assets_data.filter(func(e:AssetPackData): return e.path == data.path)
				if _found.size() == 0:
					APM.assets_data.append( data )
				
			file_name = dir_access.get_next()
		dir_access.list_dir_end()
	
	print("Assets found:")
	for n in APM.assets_data:
		print(n)

## 
## 
## 
func scan_authors():
	var dir_access = DirAccess.open(ASSET_DIR)
	if dir_access == null:
		push_error("DirScaner: Error opening directory.")
		return
	else:
		authors_dirs.clear()
		dir_access.list_dir_begin()
		var file_name: String = dir_access.get_next()
		while file_name != "":
			if dir_access.current_is_dir():
				authors_dirs.append( file_name );
			file_name = dir_access.get_next()
		dir_access.list_dir_end()
	return authors_dirs

## 
## 
## 
func read_json_file(file_path: String) -> Variant:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Error opening file: " + file_path)
		return null
	var content = file.get_as_text()
	file.close()
	var parsed_data = JSON.parse_string(content)
	if parsed_data == null:
		push_error("Error parsing JSON from file: " + file_path)
		return null
	return parsed_data
