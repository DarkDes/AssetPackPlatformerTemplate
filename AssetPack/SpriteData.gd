class_name SpriteData
extends Resource

signal texture_changed(data, texture)

@export var texture_default : Texture2D = null

@export var texture : Texture2D = null :
	set(value):
		texture = value
		texture_changed.emit(self, value)

