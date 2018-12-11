tool
extends WindowDialog

var contents = []
var dialog_file
var currentDialog
var currentTexts
var currentSpeeds

onready var newButton = get_node("VBoxContainer/PanelContainer/HBoxContainer/NewButton")
onready var loadButton = get_node("VBoxContainer/PanelContainer/HBoxContainer/LoadButton")
onready var saveButton = get_node("VBoxContainer/PanelContainer/HBoxContainer/SaveButton")

var dialog_list
onready var dialogAddButton = get_node("VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/VBoxContainer/DialogAdd")
onready var dialogRemoveButton = get_node("VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/VBoxContainer/DialogRemove")

var texts_list
onready var textAddButton = get_node("VBoxContainer/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/VBoxContainer/AddTextButton")
onready var textRemoveButton = get_node("VBoxContainer/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/VBoxContainer/RemoveTextButton")

func _ready():
	
	
	if !newButton.is_connected("pressed",self,"mainOptions"):
		newButton.connect("pressed",self,"mainOptions", [0])
	if !loadButton.is_connected("pressed",self,"mainOptions"):
		loadButton.connect("pressed",self,"mainOptions", [1])
	if !saveButton.is_connected("pressed",self,"mainOptions"):
		saveButton.connect("pressed",self,"mainOptions", [2])
	
	_init_lists()

func _init_lists():
	dialog_list = get_node("VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/DialogsList")
	dialog_list.connect("item_selected",self,"selected_dialog")
	
	texts_list = get_node("VBoxContainer/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/TextsList")
	texts_list.connect("item_selected",self,"selected_text")

func mainOptions(btn_index):
	if btn_index == 0:
		contents = []
		clear_all()
		save_file(contents)
	elif btn_index == 1:
		load_file()
	elif btn_index == 2:
		save_file(contents)
		
func clear_all():
	dialog_list.clear()
	texts_list.clear()
	print("clear all")
	
func load_file():
	var selector = FileDialog.new()
	selector.add_filter("*.json")
	selector.set_mode(selector.MODE_OPEN_FILE)
	if OS.get_real_window_size().x >= 1400:
		selector.rect_scale = Vector2(1.5,1.5)
	add_child(selector)
	selector.popup_centered(Vector2(800,600))
	dialog_file = yield(selector,"file_selected")
	
	var file = File.new()
	if file.open(dialog_file,file.READ) == OK:
		print("file opened")

		var file_array = []
		if JSON.parse(file.get_as_text()):
			print("json parsed")
			file_array = JSON.parse(file.get_as_text()).result
			contents = file_array
			get_contents()
	
func save_file(contents):
	print("save file")
	
func get_contents():
	if dialog_list == null:
		_init_lists()
	dialog_list.clear()
	var dialogs = []
	for i in range(contents.size()):
		dialogs.append(str("Dialogue ", (i + 1)))
		dialog_list.add_item(dialogs[i])
		
func selected_dialog(selected):
	currentDialog = null
	if selected == null:
		return
	else:
		currentDialog = selected
		print("Current dialog is: ",currentDialog)
		get_texts(currentDialog)
		
func get_texts(dialog_index):
	texts_list.clear()
	currentTexts = []
	currentSpeeds = []
	print ("Get texts from ", dialog_index)
	for t in contents[dialog_index][1]:
		var speed = 1
		if t.size() > 1:
			speed = t[1]
		for tx in t[0]:
			currentTexts.append(tx)
			currentSpeeds.append(speed)
	for i in range(currentTexts.size()):
		texts_list.add_item(currentTexts[i])