extends Node

@onready var animation_controller = $"../AnimationController"
@onready var player = $".."

func _physics_process(delta):
	if player.is_on_floor() and Input.is_action_pressed("action"):
		player.velocity = Vector2.ZERO
		
		player.input_disable = true
		
		animation_controller.do_action_one(func():
			player.input_disable = false
		)
