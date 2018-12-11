tool
extends EditorPlugin

var show_editor_btn
var editor_tscn = preload("res://addons/dialogs/editor.tscn")
var editor_btn
var editor

func _init():
	editor_btn = ToolButton.new()
	
func _ready():
	editor_btn.set_button_icon(preload("icon.png"))
	editor_btn.set_text("Dialogs Editor")
	editor_btn.connect("pressed",self,"_open_editor")
	editor_btn.visible = true

func _enter_tree():
	add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU,editor_btn)
	add_custom_type("Dialog", "Control", preload("dialog_box.gd"), preload("icon.png"))
	
func _exit_tree():
	editor_btn.queue_free()
	remove_custom_type("Dialog")
	
func _open_editor():
	if (editor == null):
		editor = editor_tscn.instance()
		if OS.get_real_window_size().x >= 1400:
			editor.rect_scale = Vector2(1.5,1.5)
		add_child(editor)
	editor.popup_centered()