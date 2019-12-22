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
		$ImageViewer.show_image(2)
		yield($ImageViewer, "image_shown")
		$Dialog.start_dialog(3)
	if part == 3:
		$ImageViewer.show_image(3)
		yield($ImageViewer, "image_shown")
		$Dialog.start_dialog(4)
	if part == 4:
		$ImageViewer.show_image(4)
		yield($ImageViewer, "image_shown")
		$Dialog.start_dialog(5)
	if part == 5:
		$ImageViewer.hide_image(4)
		yield($ImageViewer, "image_hidden")
		$ImageViewer.hide()
		yield($ImageViewer, "viewer_hidden")
		remove_child($ImageViewer)