extends Area2D

@onready var coin_sprite = $Node2DSnapping/CoinSprite

func _ready():
	await get_tree().process_frame
	coin_sprite.play("idle")
	coin_sprite.frame = randi_range(0, coin_sprite.sprite_frames.get_frame_count("idle"))
