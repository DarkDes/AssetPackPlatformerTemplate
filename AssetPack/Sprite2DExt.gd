class_name Sprite2DExt
extends Sprite2D

@export var sprite_data : SpriteData = null

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_data.texture_changed.connect(texture_changed)
	texture_changed(sprite_data, sprite_data.texture)

func texture_changed(sdata, _texture):
	texture = _texture
