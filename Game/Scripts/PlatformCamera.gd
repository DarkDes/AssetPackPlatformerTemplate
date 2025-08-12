extends Camera2D

@export var snapping_pixels = 1
@export var target : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target == null:
		#push_error("Camera: Target is null")
		return
	else:
		if snapping_pixels > 1:
			global_position = target.global_position.snapped(Vector2(snapping_pixels, snapping_pixels))
		else:
			global_position = target.global_position
