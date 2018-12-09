extends Node

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func change_level(scene, tag):
	call_deferred("_deferred_change_level",scene, tag)
	
func _deferred_change_level(scene, tag):
	current_scene.free()
	
	var new_scene = ResourceLoader.load(scene)
	
	current_scene = new_scene.instance()
	_player_position(current_scene, tag)
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
func _player_position(scene, tag):
	if scene.has_node("ghost") && scene.has_node("Positions"):
		var player = scene.get_node("ghost")
		var positions = scene.get_node("Positions")
		print(player, positions)