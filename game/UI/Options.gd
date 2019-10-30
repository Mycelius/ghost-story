extends Node2D

onready var config = get_node("/root/Config")

func _ready():
	$CenterContainer/VBoxContainer/HBoxContainer2/btn_Apply.connect("pressed", self, "Apply")
	$CenterContainer/VBoxContainer/HBoxContainer2/btn_Cancel.connect("pressed", self, "Cancel")
	
	var langOption = $CenterContainer/VBoxContainer/HBoxContainer/Languages
	for lng in config.AVAILABLE_LANGUAGES:
		langOption.add_item(lng)
	langOption.grab_focus()
	langOption.select(config.AVAILABLE_LANGUAGES.find(config.language))
	
func Apply():
	config.language = config.AVAILABLE_LANGUAGES[$CenterContainer/VBoxContainer/HBoxContainer/Languages.selected]
	config.applyConfig()
	config.saveConfig()
	
	get_tree().change_scene("res://UI/TitleScreen.tscn")
	
func Cancel():
	get_tree().change_scene("res://UI/TitleScreen.tscn")