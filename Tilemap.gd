extends TileMap

var TILESET_ATLAS : AtlasTexture = preload("res://Tilemap/tileset_atlas.tres")
var TILEMAP_0 = preload("res://Tilemap/tilemap_0.png")
var TILEMAP_2 = preload("res://Tilemap/tilemap_0.png")

var tiles = null

func _ready():
	tiles = TILESET_ATLAS.atlas
	
func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_CTRL and event.is_pressed():
			print("Change")
			#var k = tile_set.get_source_id(0)
			#var s : TileSetAtlasSource = tile_set.get_source(k)
			#s.texture = TILEMAP_2
			if TILESET_ATLAS.atlas == tiles:
				TILESET_ATLAS.atlas = TILEMAP_0
			else:
				TILESET_ATLAS.atlas = tiles
				
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT and event.is_pressed():
			if tile_set.tile_size == Vector2i(16,16):
				tile_set.tile_size = Vector2i(48, 48)
			else:
				tile_set.tile_size = Vector2i(16, 16)
