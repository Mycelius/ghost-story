extends MarginContainer

func _ready():
	$CenterContainer/MenuContainer/btn_newGame.connect("pressed",self,"newGame")
	$CenterContainer/MenuContainer/btn_continueGame.connect("pressed",self,"continueGame")
	$CenterContainer/MenuContainer/btn_options.connect("pressed",self,"options")
	$CenterContainer/MenuContainer/btn_quit.connect("pressed",self,"quit")
		

func newGame():
	get_tree().change_scene("res://level-00/level_0.tscn")
	
func continueGame():
	print("continue")
	
func options():
	get_tree().change_scene("res://UI/Options.tscn")
	
func quit():
	get_tree().quit()