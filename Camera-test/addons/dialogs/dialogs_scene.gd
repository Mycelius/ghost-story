extends Control

var label
var timer
var dialog = ["Bonjour, [b][i]ceci[/i][/b] [color=red]est[/color] un [b]texte[/b] de [i]test[/i]", "Ceci est la suite du texte de test"] setget set_dialog
var index = 0 setget set_index
export(float) var speed setget set_speed

func _init():
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_IDLE)
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)
	
	
func _ready():
	label = get_node("NinePatchRect/RichTextLabel")
	set_index(index)
	label.set_visible_characters(0)
	set_speed(speed)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if label.visible_characters >= label.get_total_character_count():
			set_index(index + 1)
		else:
			label.set_visible_characters(label.get_total_character_count())
			
func _on_Timer_timeout():
	label.set_visible_characters(label.visible_characters + 1)

func set_speed(new_speed):
	speed = new_speed
	if speed == null:
		speed = 1
	if timer.is_processing():
		timer.stop()
	timer.set_wait_time(speed / 100.00)
	timer.start()
	
func set_index(new_index):
	index = new_index
	if dialog.size() >= index + 1:
		label.set_visible_characters(0)
		label.bbcode_text = dialog[index]
	
	
func set_dialog(new_dialog):
	dialog = new_dialog