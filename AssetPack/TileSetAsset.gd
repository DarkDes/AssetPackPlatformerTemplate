class_name TileSetAsset
extends TileSet

signal texture_changed

@export var pixel_size := 1 # 1, 2, 3
@export var texture_default : Texture2D = null
@export var pixelated : bool = true :
	set(value):
		pixelated = value
		texture_changed.emit()

@export var texture : Texture2D = null :
	set(value):
		texture = value
		texture_changed.emit()


