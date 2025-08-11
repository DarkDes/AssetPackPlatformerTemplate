class_name DangerArea
extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body:Node2D):
	if body.is_in_group("damageable"):
		if "damaged" in body:
			body.damaged.emit() # (self)
