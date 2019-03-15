extends Spatial

onready var tile = load("res://infinite_tile.tscn")

var TILE_SIZE = 4.0

func _ready():
	draw_tiles()

func _player_entered():
	print("hello")
	
func draw_tiles():
	var tiles = []
	for i in range(3):
		tiles.append(tile.instance())
		tiles[i].connect("player_entered", self, "_player_entered")
		tiles[i].translate(Vector3(TILE_SIZE * i,0.0,0.0))
		add_child(tiles[i])