class_name AnimatedSprite2DAsset
extends AnimatedSprite2D

@export var sprite_name : String = ""
# Это необходимо только для Sprite2D, 
# для анимированного можно использовать SpriteFrames
# @export var sprite_data : SpriteData = null

var sprite_frames_asset : SpriteFramesAsset = null

func _ready():
	# Подписаться на изменения
	sprite_frames_asset = sprite_frames as SpriteFramesAsset 
	sprite_frames_asset.textures_changed.connect(on_sprite_frames_textures_changed)
	on_sprite_frames_textures_changed(sprite_frames)
	
	sprite_frames_asset.catch_default_texture()
	
	sprite_frames_changed.connect(on_sprite_frames_changed)
	play("idle")

func on_sprite_frames_changed():
	sprite_frames_asset.textures_changed.disconnect(on_sprite_frames_textures_changed)
	sprite_frames_asset = sprite_frames as SpriteFramesAsset 
	sprite_frames_asset.textures_changed.connect(on_sprite_frames_textures_changed)
	on_sprite_frames_textures_changed(sprite_frames)

func on_sprite_frames_textures_changed(sprite_frames_asset : SpriteFramesAsset):
	if sprite_frames_asset.pixelated: 
		texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	else:
		texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
