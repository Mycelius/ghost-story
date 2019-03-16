extends Spatial

onready var tile = load("res://infinite_tile.tscn")

var TILE_SIZE = 4.0
var tiles = []
var current_tile = Vector2(0.0, 0.0)

func _ready():
	init_tiles()

func _player_entered(entered):
	if entered != current_tile:
		update_tiles(entered)
		current_tile = entered
	
func init_tiles():
	for i in range(3):
		tiles.append([])
		for j in range(3):
			add_tile(i, j)

func update_tiles(entered):
	pass
	
func add_tile(i, j):
	var x = TILE_SIZE * (i - 1.0)
	var y = TILE_SIZE * (j - 1.0)
	tiles[i].append(tile.instance())
	tiles[i][j].translate(Vector3(x,0.0,y))
	tiles[i][j].connect("player_entered", self, "_player_entered", [Vector2(x, y)])
	add_child(tiles[i][j])