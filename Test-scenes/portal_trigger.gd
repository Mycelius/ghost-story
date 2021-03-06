extends Area

export(String, FILE, "*.tscn") var scene
export(String) var tag

func _ready():
	pass

func _on_Portal_body_entered(body):
	var wall_visible = get_parent().visible
	if wall_visible && body.has_method("is_player"):
		var pivot = get_tree().get_current_scene().get_node("camera-system/pivot")
		var product = pivot.get_global_transform().basis.x.angle_to(get_global_transform().basis.z)
		get_node("/root/global").change_level(scene, tag, product)