extends Spatial

onready var tile = load("res://infinite_tile.tscn")

func _ready():
	var tile1 = tile.instance()
	tile1.connect("player_entered", self, "_player_entered")
	"tile1.translate(Vector3(4.0,0.0,4.0))"
	add_child(tile1)

func _player_entered():
	print("hello")