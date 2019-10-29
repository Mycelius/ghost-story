extends Node2D

const AVAILABLE_LANGUAGES = ['fr', 'en']

func _ready():
	$CenterContainer/VBoxContainer/HBoxContainer2/btn_Apply.connect("pressed", self, "Apply")
	$CenterContainer/VBoxContainer/HBoxContainer2/btn_Cancel.connect("pressed", self, "Cancel")
	
	var langOption = $CenterContainer/VBoxContainer/HBoxContainer/Languages
	for lng in AVAILABLE_LANGUAGES:
		langOption.add_item(lng)
	langOption.grab_focus()
	
func Apply():
	pass
	
func Cancel():
	get_tree().change_scene("res://UI/TitleScreen.tscn")