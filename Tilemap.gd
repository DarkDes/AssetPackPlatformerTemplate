class_name TileMapAsset
extends TileMap

func _ready():
	tile_set.texture_changed.connect(texture_changed)
	
func texture_changed():
	# По какой-то ГОДОТ причине это не работает.
	if tile_set.pixelated:
		texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		print("Tilemap Texture filter changed to TEXTURE_FILTER_NEAREST")
	else:
		texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		print("Tilemap Texture filter changed to TEXTURE_FILTER_LINEAR")
