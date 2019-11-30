extends Spatial

var seconds = 0

func _ready():
	$ImageViewer.show_image(0)
	yield($ImageViewer, "image_shown")
	$Dialog.start_dialog(1)

func _on_Dialog_blockFinished(part):
	if part == 1:
		$ImageViewer.show_image(1)
		yield($ImageViewer, "image_shown")
		$Dialog.start_dialog(2)
	if part == 2:
		$ImageViewer.hide_image(1)
		yield($ImageViewer, "image_hidden")
		$ImageViewer.hide()
