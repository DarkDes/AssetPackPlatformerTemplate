extends Control

@onready var lives_label = $VBoxContainer/UILivesText/LivesLabel
@onready var coins_label = $VBoxContainer/UICoins/CoinsLabel

#func _ready():
	#GD.stats_changed.connect(update_text)
#func update_text():
func _process(delta):
	lives_label.text = "x " + str(GD.lives)
	coins_label.text = "x " + str(GD.coins)
