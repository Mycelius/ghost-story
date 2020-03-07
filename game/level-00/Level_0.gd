extends Spatial

var seconds = 0
var camera_position

func _ready():
	$Transitions.hide_cache()
	$ImageViewer.show_image(0)
	yield($ImageViewer, "image_shown")
	$Dialog.start_dialog(1)
	camera_position = $Camera.transform.origin
	$Camera.look_at($"AnimationPlayer/Position3D".transform.origin,Vector3.UP)

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
		$Dialog.start_dialog(6)
	if part == 6:
		$AnimationPlayer.play("mouvement")

func _process(delta):
	$Camera.look_at($"AnimationPlayer/Position3D".transform.origin,Vector3.UP)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "mouvement":
		$Transitions.fade_out()
		yield($Transitions,"transition_complete")
		get_tree().change_scene("res://level-01/Level_01_01.tscn")
