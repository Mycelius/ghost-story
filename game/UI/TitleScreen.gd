extends Control

func _ready():
	$MainContainer/MenuContainer.get_child(0).grab_focus()
	for button in $MainContainer/MenuContainer.get_children():
		button.connect("pressed", self, "_on_button_pressed", [button.scene_to_load])
		

func _on_button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)