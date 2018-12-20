extends Area

export(String) var tag

func _ready():
	pass

func _on_InnerPortal_body_entered(body):
	var wall_visible = get_parent().visible
	if wall_visible && body.has_method("is_player"):
		var pos = _get_position()
		if pos != null:
			body.transform.basis = pos.transform.basis
			body.transform.origin = Vector3(pos.transform.origin.x, body.transform.origin.y, pos.transform.origin.z)
		
func _get_position():
	var positions = get_tree().get_current_scene().get_node("Positions")
	if positions != null:
		for pos in positions.get_children():
			if pos.tag == tag:
				return pos	