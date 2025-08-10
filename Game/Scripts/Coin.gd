extends Area2D

@onready var coin_sprite = $CoinSprite

func _ready():
	coin_sprite.play("idle")
	coin_sprite.set_frame_and_progress( randi_range(0, coin_sprite.sprite_frames.get_frame_count("idle")), 0.0 )
