class_name SpriteFramesAsset
extends SpriteFrames

# может это не надо т.к. есть name самого файла
# @export var name : String = ""


signal textures_changed(data)

@export var texture_default : Texture2D = null

@export var pixelated : bool = false :
	set(value):
		pixelated = value
		send_updated()

@export var texture : Texture2D = null :
	set(value):
		texture = value
		send_updated()

func default():
	for anim in get_animation_names():
		clear(anim)
		add_frame(anim, texture_default)
	pixelated = true
	send_updated()

func default_animation(animation_name):
	if animation_name in get_animation_names():
		clear(animation_name)
		add_frame(animation_name, texture_default)
	send_updated()
	
func send_updated():
	textures_changed.emit(self)

func catch_default_texture():
	if texture_default == null:
		for anim in get_animation_names():
			texture_default = get_frame_texture(anim, 0)
			default()
			return
			
