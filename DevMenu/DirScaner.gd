extends Node

#const ASSET_DIR : String = "res://Assets"
var ASSET_DIR : String = OS.get_executable_path().get_base_dir().path_join("Assets")
const SETTINGS_FILE : String = "settings.json"

var authors_dirs = []
var assets = []

func _ready():
	if FileAccess.file_exists(ASSET_DIR) == false:
		ASSET_DIR = "res://Assets"

func scan_asset_directory():
	var dir_access = DirAccess.open(ASSET_DIR) #OS.get_executable_path().get_base_dir().path_join("Assets"))
	if dir_access == null:
		print("DirScaner: Error opening directory.")
		return
	else:
		authors_dirs = []
		dir_access.list_dir_begin() # Exclude "." and ".."
		var file_name: String = dir_access.get_next()
		while file_name != "":
			if dir_access.current_is_dir():
				authors_dirs.append( file_name );
				# Recursively call for subdirectories
				#files.append_array(get_all_files_in_directory(path.path_join(file_name)))
			#else:
				# Add file to the list
				#files.append(path.path_join(file_name))
			file_name = dir_access.get_next()
		dir_access.list_dir_end()
	
	for author in authors_dirs:
		var author_path = ASSET_DIR.path_join(author)
		dir_access = DirAccess.open(author_path)
		dir_access.list_dir_begin()
		var file_name: String = dir_access.get_next()
		while file_name != "":
			var settings_path = author_path.path_join(file_name).path_join(SETTINGS_FILE)
			if dir_access.current_is_dir() and FileAccess.file_exists(settings_path):
				var data = { 
					"name": author + " - " + file_name, 
					"path": author_path.path_join(file_name),
					"data": read_json_file(settings_path)
				}
				var settings_data = data.data;
				
				# Check Name
				if settings_data != null:
					if "name" in settings_data and "author" in settings_data:
						data.name = settings_data.author + " - " + settings_data.name
				
				assets.append( data )
			file_name = dir_access.get_next()
		dir_access.list_dir_end()
	
	for n in assets:
		print(n)

func read_json_file(file_path: String) -> Variant:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("Error opening file: " + file_path)
		return null
	var content = file.get_as_text()
	file.close()
	var parsed_data = JSON.parse_string(content)
	if parsed_data == null:
		print("Error parsing JSON from file: " + file_path)
		return null
	return parsed_data
