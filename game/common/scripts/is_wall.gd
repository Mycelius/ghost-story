extends Spatial

var pivot

func _ready():
	pivot = get_parent().get_node("camera-system").get_node("pivot")

func _process(delta):
	if pivot != null:
		transform = transform.orthonormalized()
		pivot.transform = pivot.transform.orthonormalized()
		var gridmap = $GridMap
		var direction = transform.basis.z
		if direction.dot(pivot.global_transform.basis.z) > 0:
			hide()
			if gridmap != null:
				gridmap.hide()
		else:
			show()
			if gridmap != null:
				gridmap.show()