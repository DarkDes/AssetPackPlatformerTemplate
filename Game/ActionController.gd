extends Node

@onready var animation_controller = $"../AnimationController"
@onready var player = $".."

func _physics_process(delta):
	if player.is_on_floor() and Input.is_action_pressed("action"):
		player.velocity = Vector2.ZERO
		animation_controller.sprite.play("action")
		player.process_mode = Node.PROCESS_MODE_DISABLED
		animation_controller.process_mode = Node.PROCESS_MODE_DISABLED
		var sframes := animation_controller.sprite.sprite_frames as SpriteFramesAsset
		if sframes.get_frame_count("action") > 1:
			await animation_controller.sprite.animation_finished
			animation_controller.process_mode = Node.PROCESS_MODE_INHERIT
			player.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			await get_tree().create_timer(1.0).timeout
			animation_controller.process_mode = Node.PROCESS_MODE_INHERIT
			player.process_mode = Node.PROCESS_MODE_INHERIT
		# animation_controller.sprite.play("idle")
