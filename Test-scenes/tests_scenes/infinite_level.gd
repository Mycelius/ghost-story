extends Spatial

onready var tile = load("res://infinite_tile.tscn")

var TILE_SIZE = 4.0
var tiles = []
var current_tile_pos = Vector2(0.0, 0.0)

func _ready():
	init_tiles()

func _player_entered(entered):
	if entered != current_tile_pos:
		update_tiles(entered)
		current_tile_pos = entered
	
func init_tiles():
	for i in range(3):
		tiles.append([])
		for j in range(3):
			add_tile(tiles, i, j)

func update_tiles(entered):
	if current_tile_pos.x - entered.x > 0:
		shift_tiles(1,"x")
	elif current_tile_pos.x - entered.x < 0:
		shift_tiles(-1, "x")
		
	if current_tile_pos.y - entered.y > 0:
		shift_tiles(1,"y")
	elif current_tile_pos.y - entered.y < 0:
		shift_tiles(-1, "y")

func shift_tiles(direction, axis):
	var new_tiles = []
	for i in range(3):
		new_tiles.append([])
		if axis == "y":
			print(axis, direction)
		for j in range(3):
			if axis == "x":
				print(axis, direction)

func add_tile(tiles_array, i, j):
	var x = current_tile_pos.x + TILE_SIZE * (i - 1.0)
	var y = current_tile_pos.y + TILE_SIZE * (j - 1.0)
	tiles_array[i].append(tile.instance())
	tiles_array[i][j].translate(Vector3(x,0.0,y))
	tiles_array[i][j].connect("player_entered", self, "_player_entered", [Vector2(x, y)])
	add_child(tiles_array[i][j])