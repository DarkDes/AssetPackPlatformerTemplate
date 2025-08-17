extends CanvasLayer

@onready var hud = $HUD
@onready var dev_menu = $DevMenu
@onready var starting_animation = $StartingAnimation

func _ready():
	dev_menu.skip_intro.toggled.connect(
		func(_toggled):
			starting_animation.disabled = _toggled
	)
	
