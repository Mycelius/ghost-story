extends Spatial

onready var tile = load("res://level-01/InfiniteTile.tscn")

var TILE_SIZE = 24.0
var tiles = []
var next_tiles = []
var current_tile_pos = Vector2(0.0, 0.0)
var wait = false

func _ready():
	init_tiles()

func _player_entered(entered):
	if entered != current_tile_pos:
		next_tiles.append(entered)
		
func _player_exited(exited):
	if exited == current_tile_pos:
		if next_tiles.size() > 2:
			wait = true
		else:
			move(next_tiles[0])
			
	elif exited != current_tile_pos:
		var index = next_tiles.find(exited)
		if index > -1:
			next_tiles.remove(index)
			if wait && next_tiles.size() <= 2:
				move(next_tiles[0])
				wait = false
	
func init_tiles():
	for i in range(3):
		tiles.append([])
		for j in range(3):
			add_tile(i, j)

func move(next_tile):
	var index = next_tiles.find(next_tile)
	if index > -1:
		next_tiles.remove(index)
	var move = get_move(next_tile)
	current_tile_pos = next_tile
	update_tiles(move)

func update_tiles(move):
	remove_tiles(move)
	slide_array(move)
	refill_tiles()

func remove_tiles(move):
	if move.y != 0:
		var c = 1 + move.y
		for i in range(3):
			remove_child(tiles[i][c])
			tiles[i][c] = null
	if move.x != 0:
		var c = 1 + move.x
		for i in range(3):
			if tiles[c][i] != null:
				remove_child(tiles[c][i])
		tiles[c] = null
			
func slide_array(move):
	var new_tiles = tiles
	if move.x != 0:
		new_tiles = shift_array(new_tiles, move.x)
	if move.y != 0:
		for i in range(3):
			if new_tiles[i] != null:
				new_tiles[i] = shift_array(new_tiles[i], move.y)
	tiles = new_tiles

func shift_array(to_shift, direction):
	if direction > 0:
		to_shift.pop_back()
		to_shift.push_front(null)
	elif direction < 0:
		to_shift.pop_front()
		to_shift.push_back(null)
	return to_shift

func refill_tiles():
	for i in range(3):
		if tiles[i] == null:
			tiles[i] = []
		for j in range(3):
			if tiles[i].size() < 3 || tiles[i][j] == null:
				add_tile(i,j)

func get_move(entered):
	var current_move = Vector2(0,0)
	if current_tile_pos.x - entered.x > 0:
		current_move.x = 1
	elif current_tile_pos.x - entered.x < 0:
		current_move.x = -1
		
	if current_tile_pos.y - entered.y > 0:
		current_move.y = 1
	elif current_tile_pos.y - entered.y < 0:
		current_move.y = -1
	
	return current_move

func add_tile(i, j):
	var x = current_tile_pos.x + TILE_SIZE * (i - 1.0)
	var y = current_tile_pos.y + TILE_SIZE * (j - 1.0)
	if tiles[i].size() == j:
		tiles[i].append(tile.instance())
	else:
		tiles[i][j] = tile.instance()
	tiles[i][j].translate(Vector3(x,0.0,y))
	tiles[i][j].connect("player_entered", self, "_player_entered", [Vector2(x, y)])
	tiles[i][j].connect("player_exited", self, "_player_exited", [Vector2(x, y)])
	add_child(tiles[i][j])