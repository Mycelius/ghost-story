extends Spatial

var pivot

func _ready():
	pivot = get_parent().get_node("camera-system").get_node("pivot")

func _process(delta):
	if pivot != null:
		transform = global_transform.orthonormalized()
		pivot.transform = pivot.transform.orthonormalized()
		var direction = global_transform.basis.z
		if direction.dot(pivot.global_transform.basis.z) > 0:
			hide()
		else:
			show()