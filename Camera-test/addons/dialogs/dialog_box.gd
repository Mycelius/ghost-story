tool
extends Control

var dialog_box
var dialog
export (String, FILE, "*.json") var json_file

func _enter_tree():
	dialog_box = preload("res://addons/dialogs/dialogs.tscn")
	
	
	var file = File.new()
	file.open(json_file, file.READ)
	dialog = JSON.parse(file.get_as_text())
	
func start_dialog(part):
	if dialog.result.size() >= part:
		var part_array = dialog.result[part - 1]
		var pos = part_array[0]
		var texts = part_array[1]
		start_dialog_box(texts, pos)

func start_dialog_box(texts, pos):
	dialog_box = dialog_box.instance()
	dialog_box.set_dialog(texts[0])
	add_child(dialog_box)