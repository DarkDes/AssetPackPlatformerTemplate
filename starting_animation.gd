extends Control

func _ready():
	APM.asset_changed.connect(func(asset : AssetPackData): show_asset_text(asset))
	show_asset_text(APM.current)
	
func show_asset_text(asset : AssetPackData):
	visible = true
	get_node("Control/Nickname").text = asset.author_name
	get_node("Control/Assetname").text = asset.display_name
	(get_node("AnimationPlayer") as AnimationPlayer).play("starting")
	await (get_node("AnimationPlayer") as AnimationPlayer).animation_finished
	visible = false
