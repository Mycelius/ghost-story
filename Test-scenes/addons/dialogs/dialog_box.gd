tool
extends Control


var viewport_w
var viewport_h

var width = 1000.00
var height = 300.00
var pos_top = 0.00
var pos_left = 0.00

var dialog_box_scene
var dialog_box
var dialog
export (String, FILE, "*.json") var json_file

signal blockFinished(part)

func _enter_tree():
	dialog_box_scene = preload("res://addons/dialogs/dialogs.tscn")
	var file = File.new()
	file.open(json_file, file.READ)
	dialog = JSON.parse(file.get_as_text())
	
	viewport_w = get_viewport().get_visible_rect().size.x
	viewport_h = get_viewport().get_visible_rect().size.y
	
func start_dialog(part):
	if dialog.result.size() >= part:
		var part_array = dialog.result[part - 1]
		var pos = part_array[0]
		var texts = part_array[1]
		start_dialog_box(texts, pos, part)
		
func remove_dialog(part):
	remove_child(dialog_box)
	emit_signal("blockFinished", part)

func start_dialog_box(texts, pos, part):
	set_box_size(pos)
	dialog_box = dialog_box_scene.instance()
	dialog_box.connect("text_finished", self, "remove_dialog", [part])
	rect_position = Vector2(pos_left, pos_top)
	rect_size = Vector2(width, height)
	rect_scale = Vector2(1,1)
	dialog_box.set_dialog(texts)
	add_child(dialog_box)
	
func set_box_size(pos):
	
	height = round(viewport_h / 3)
	
	if pos in ["T", "M", "B"]:
		width = viewport_w
	else:
		width = round(viewport_w / 3)
	
	if pos in ["TL", "ML", "BL"]:
		pos_left = 0
	elif pos in ["TM", "MM", "BM"]:
		pos_left = width
	elif pos in ["TR", "MR", "BR"]:
		pos_left = 2*width
		
	if pos in ["T", "TL", "TM", "TR"]:
		pos_top = 0
	elif pos in ["M", "ML", "MM", "MR"]:
		pos_top = height
	elif pos in ["B", "BL", "BM", "BR"]:
		pos_top = 2*height