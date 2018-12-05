extends Spatial

var dialog

func _ready():
	dialog = get_node("Dialog")
	dialog.connect("blockFinished", self, "block_is_finished")
	dialog.start_dialog(1)
	
func block_is_finished(part):
	if part == 1:
		dialog.start_dialog(2)
	elif part == 2:
		dialog.start_dialog(3)
	elif part == 3:
		dialog.start_dialog(4)