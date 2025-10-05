class_name Node2DSnapping
extends Node2D

@export var snapping_setting : SnappingSetting = preload("res://Game/snapping.tres")
var sprite : AnimatedSprite2DAsset = null
var sprite_width : int = 0
var sprite_height : int = 0

func _ready():
	sprite = get_child(0) as AnimatedSprite2DAsset
	sprite.sprite_frames_asset.textures_changed.connect(on_sprite_frames_textures_changed)
	
func _process(delta):
	var _half = Vector2(sprite_width/2.0, sprite_height/2.0) * sprite.scale.y
	var _pos = global_position - _half
	sprite.global_position = snapping_setting.snap(_pos) + _half

# 
func on_sprite_frames_textures_changed(sprite_frames_asset : SpriteFramesAsset):
	var _texture = sprite_frames_asset.get_frame_texture("idle", 0)
	if _texture == null: _texture = sprite_frames_asset.get_frame_texture("dying", 0) # enemy, чем такой особенный?
	if _texture:
		sprite_width = _texture.get_width()
		sprite_height = _texture.get_height()
	else:
		sprite_width = 1
		sprite_height = 1
		print("Texture is null in sprite snapper")

	if snapping_setting:
		snapping_setting.snapping_scale = float(sprite_frames_asset.sprite_scale)
