class_name TileSetAsset
extends TileSet

signal texture_changed(data, texture)

@export var pixel_size := 1 # 1, 2, 3
@export var texture_default : Texture2D = null
@export var texture : Texture2D = null :
	set(value):
		texture = value
		texture_changed.emit(self, value)


