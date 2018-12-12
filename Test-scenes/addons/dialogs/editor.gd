tool
extends WindowDialog

# Position constants
const VT = 1
const VM = 2
const VB = 3

const HNONE = 1
const HL = 2
const HM = 3
const HR = 4

const DEFAULT_POSITION = "B"

# Main variables
var contents = []
var dialog_file
var currentDialog
var currentPosition
var currentTexts
var currentSpeeds
var currentText

# Menu buttons
onready var newButton = get_node("VBoxContainer/PanelContainer/HBoxContainer/NewButton")
onready var loadButton = get_node("VBoxContainer/PanelContainer/HBoxContainer/LoadButton")
onready var saveButton = get_node("VBoxContainer/PanelContainer/HBoxContainer/SaveButton")

# Dialog buttons
var dialog_list
onready var dialogAddButton = get_node("VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/VBoxContainer/DialogAdd")
onready var dialogRemoveButton = get_node("VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/VBoxContainer/DialogRemove")

# Dialog position
onready var vAlign = get_node("VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/vAlignButton")
onready var hAlign = get_node("VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/hAlignButton")

# Texts buttons
var texts_list
onready var textAddButton = get_node("VBoxContainer/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/VBoxContainer/AddTextButton")
onready var textRemoveButton = get_node("VBoxContainer/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/VBoxContainer/RemoveTextButton")

# Text and speed editor
onready var textEditor = get_node("VBoxContainer/PanelContainer3/HBoxContainer/VBoxContainer2/TextEdit")
onready var speedEditor = get_node("VBoxContainer/PanelContainer3/HBoxContainer/VBoxContainer/SpeedEdit")

# Indo message
onready var message = get_node("VBoxContainer/PanelContainer4/Message")

func _ready():
	
	
	if !newButton.is_connected("pressed",self,"mainOptions"):
		newButton.connect("pressed",self,"mainOptions", [0])
	if !loadButton.is_connected("pressed",self,"mainOptions"):
		loadButton.connect("pressed",self,"mainOptions", [1])
	if !saveButton.is_connected("pressed",self,"mainOptions"):
		saveButton.connect("pressed",self,"mainOptions", [2])
	
	_init_lists()
	
	# Connections
	dialogAddButton.connect("pressed", self, "create_dialog")
	dialogRemoveButton.connect("pressed", self, "remove_dialog")
	textAddButton.connect("pressed", self, "create_text")
	textRemoveButton.connect("pressed", self, "remove_text")

func _init_lists():
	dialog_list = get_node("VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/DialogsList")
	dialog_list.connect("item_selected",self,"selected_dialog")
	
	texts_list = get_node("VBoxContainer/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/TextsList")
	texts_list.connect("item_selected",self,"selected_text")

# Main options choice
func mainOptions(btn_index):
	if btn_index == 0:
		contents = []
		clear_all()
		save_file(contents)
	elif btn_index == 1:
		load_file()
	elif btn_index == 2:
		save_file(contents)
		
# Clear all
func clear_all():
	dialog_list.clear()
	texts_list.clear()
	textEditor.set_text("")
	speedEditor.set_value(0)
	vAlign.select(-1)
	hAlign.select(-1)
	dialog_file = null
	currentDialog = null
	currentPosition = null
	currentTexts = []
	currentSpeeds = []
	currentText = null
	
# Load the file
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
			populate_dialogs_list()
			message.set_text("Json file imported")
		else:
			message.set_text("Error parsing Json")
	else:
		message.set_text("Error reading the file")
		
# Save the file
func save_file(contents):
	var file = File.new()
	if dialog_file == null:
		var selector = FileDialog.new()
		selector.add_filter("*.json")
		selector.set_title("Save file")
		selector.set_mode(selector.MODE_SAVE_FILE)
		if OS.get_real_window_size().x >= 1400:
			selector.rect_scale = Vector2(1.5,1.5)
		add_child(selector)
		message.set_text("Json file created")
		selector.popup_centered(Vector2(800,600))
		dialog_file = yield(selector,"file_selected")
	if file.open(dialog_file, file.WRITE) == OK:
		file.store_string(JSON.print(contents))
		message.set_text("File saved successfully")
		file.close()
	else:
		message.set_text("Error while saving file")
	
# Get the dialog list contents		
func populate_dialogs_list():
	if dialog_list == null:
		_init_lists()
	dialog_list.clear()
	for i in range(contents.size()):
		dialog_list.add_item(str("Dialogue ", (i + 1)))
		
# A dialog is selected
func selected_dialog(selected):
	currentDialog = null
	if selected == null:
		return
	else:
		currentDialog = selected
		print("Current dialog is: ",currentDialog)
		get_texts(currentDialog)
		get_positions(currentDialog)
		
# Get the texts from the selected dialog
func get_texts(dialog_index):
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
	populate_texts_list()

func populate_texts_list():
	texts_list.clear()
	for i in range(currentTexts.size()):
		texts_list.add_item(currentTexts[i])

# Get the position info of the current dialog
func get_positions(dialog_index):
	var pos = contents[dialog_index][0]
	var vpos = -1
	var hpos = HNONE
	if pos.length() == 1:
		vpos = get(str("V", pos))
	elif pos.length() == 2:
		vpos = get(str("V", pos[0]))
		hpos = get(str("H", pos[1]))
	else:
		message.set_text("Error getting the position")
	vAlign.select(vpos)
	hAlign.select(hpos)

# When a text is selected
func selected_text(selected):
	currentText = selected
	populate(currentText)
	
# Populate the text and speed editor
func populate(selectedText):
	textEditor.set_text(currentTexts[selectedText])
	speedEditor.set_value(currentSpeeds[selectedText])


####### Texts Manipulations #######

func create_text():
	currentTexts.append("New text")
	currentSpeeds.append(1)
	populate_texts_list()
	selected_text(currentTexts.size())
	
func remove_text():
	if currentText != null:
		currentTexts.remove(currentText)
		currentSpeeds.remove(currentText)
		currentText = null
		populate_texts_list()
		textEditor.set_text("")
	else:
		message.set_text("No text selected")


####### Dialog Manipulation #######

func create_dialog():
	var new_dialog = [DEFAULT_POSITION, []]
	contents.append(new_dialog)
	populate_dialogs_list()
	
func remove_dialog():
	if currentDialog != null:
		contents.remove(currentDialog)
		populate_dialogs_list()
		currentDialog = null
	else:
		message.set_text("No dialog selected")