extends Camera2D

@export var target : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == null:
		#push_error("Camera: Target is null")
		return
	else:
		global_position = target.global_position
