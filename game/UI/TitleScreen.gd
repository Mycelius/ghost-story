extends Control

onready var config = get_node("/root/Config")

func _ready():
	$Dummy/MenuContainer/btn_newGame.connect("pressed",self,"newGame")
	$Dummy/MenuContainer/btn_continueGame.connect("pressed",self,"continueGame")
	$Dummy/MenuContainer/btn_options.connect("pressed",self,"options")
	$Dummy/MenuContainer/btn_quit.connect("pressed",self,"quit")
	
	$Dummy/MenuContainer/btn_newGame.grab_focus()
	
	

func newGame():
	get_tree().change_scene("res://level-00/level_0.tscn")
	
func continueGame():
	print("continue")
	
func options():
	get_tree().change_scene("res://UI/Options.tscn")
	
func quit():
	get_tree().quit()