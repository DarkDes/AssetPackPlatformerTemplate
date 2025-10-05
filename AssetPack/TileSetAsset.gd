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
	
	# За базу взят размер HD для тайлсета.
	# Поэтому, нужно из любого размера изменить в HD (240x240)
	var max_width := 80 * 3 # pixel_size
	var max_height := 80 * 3 # pixel_size

	if image.get_size() == Vector2i(max_width, max_height):
		_tile_atlas.texture = ImageTexture.create_from_image(image)
	else:
		var _new_image := image.duplicate(false)
		var interpolate := Image.INTERPOLATE_NEAREST if pixelated else Image.INTERPOLATE_BILINEAR
		_new_image.resize(max_width, max_height, interpolate)
		_tile_atlas.texture = ImageTexture.create_from_image(_new_image)
	

