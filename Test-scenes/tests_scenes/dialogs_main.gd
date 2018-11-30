extends Spatial

func _ready():
	var dialog = get_node("Dialog")
	dialog.start_dialog(1)