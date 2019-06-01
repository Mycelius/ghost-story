extends Node2D

const AVAILABLE_LANGUAGES = ['fr', 'en']

func _ready():
	var langOption = $CenterContainer/VBoxContainer/HBoxContainer/Languages
	for lng in AVAILABLE_LANGUAGES:
		langOption.add_item(lng)
	langOption.grab_focus()
	
