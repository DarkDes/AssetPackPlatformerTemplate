class_name TileSetAsset
extends TileSet

signal texture_changed

@export var pixel_size := 1 # 1, 2, 3
@export var texture_default : Texture2D = null
@export var pixelated : bool = true :
	set(value):
		pixelated = value
		texture_changed.emit()
@export var image : Image = null : set = set_image
@export var texture : Texture2D = null :
	set(value):
		texture = value
		update_image()
		texture_changed.emit()


func set_image(value : Image):
	image = value
	update_image()
	texture_changed.emit()

func update_image():
	var _tile_source_id = get_source_id(0)
	var _tile_source = get_source(_tile_source_id)
	var _tile_atlas = _tile_source as TileSetAtlasSource
	
	if pixel_size == 3 and image.get_size() == Vector2i(80,80):
		var _new_image = image.duplicate(false)
		if pixelated:
			_new_image.resize(80*3, 80*3, Image.INTERPOLATE_NEAREST)
		else:
			_new_image.resize(80*3, 80*3, Image.INTERPOLATE_BILINEAR)
		_tile_atlas.texture = ImageTexture.create_from_image(_new_image)
	else:
		_tile_atlas.texture = ImageTexture.create_from_image(image)

