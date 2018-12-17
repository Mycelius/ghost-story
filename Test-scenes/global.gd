extends Node

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func change_level(scene, tag, angle):
	call_deferred("_deferred_change_level",scene, tag, angle)
	
func _deferred_change_level(scene, tag, angle):
	current_scene.free()
	
	var new_scene = ResourceLoader.load(scene)
	
	current_scene = new_scene.instance()
	var pos = _player_position(current_scene, tag)
	_camera_rotation(current_scene, angle, pos)
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
func _player_position(scene, tag):
	if scene.has_node("ghost") && scene.has_node("Positions"):
		var player = scene.get_node("ghost")
		var positions = scene.get_node("Positions")
		for pos in positions.get_children():
			if pos.tag == tag:
				player.transform.basis = pos.transform.basis
				player.transform.origin = Vector3(pos.transform.origin.x, player.transform.origin.y, pos.transform.origin.z)
				return pos

func _camera_rotation(scene, angle, pos):
	if scene.has_node("camera-system") && pos != null:
		var camera = scene.get_node("camera-system")
		var pos_angle = pos.transform.basis.get_euler().y
		camera.rotate_y(pos_angle + PI/4 - angle)