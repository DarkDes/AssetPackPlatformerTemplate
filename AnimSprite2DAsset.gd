class_name AnimatedSprite2DAsset
extends AnimatedSprite2D

@export var sprite_name : String = ""

func _ready():
	# super._ready()
	APM.add_sprite(sprite_name, self)
