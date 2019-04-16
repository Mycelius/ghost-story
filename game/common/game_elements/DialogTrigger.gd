extends Area

export (int) var dialog_num = 1
export (bool) var one_shot = false

var dialog = null
var active = true

func _ready():
	dialog = get_tree().get_current_scene().get_node("Dialog")


func _on_body_entered(body):
	if active && body.has_method("is_player"):
		if one_shot:
			active = false
		dialog.start_dialog(dialog_num)
