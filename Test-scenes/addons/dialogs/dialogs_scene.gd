extends Control

const DEFAULT_SPEED = 1

var label
var timer
var dialog = [[["Bonjour, [b][i]ceci[/i][/b] [color=red]est[/color] un [b]texte[/b] de [i]test[/i]", "Ceci est la suite du texte de test"]],[["un texte plus lent"], 10]] setget set_dialog
var text_nbr = 0
var index = 0 
export(float) var speed setget set_speed

signal text_finished

func _init():
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_IDLE)
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)
	
	
func _ready():
	label = get_node("NinePatchRect/RichTextLabel")
	set_index(text_nbr, index)
	label.set_visible_characters(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if label.visible_characters >= label.get_total_character_count():
			set_index(text_nbr, index + 1)
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
	if speed > 0:
		speed = speed / 100.00
	timer.set_wait_time(speed)
	timer.start()
	
func set_index(nbr, new_index):
	index = new_index
	if dialog.size() > nbr && dialog[nbr][0].size() >= index + 1:
		var new_speed = DEFAULT_SPEED
		if dialog[nbr].size() > 1:
			new_speed = dialog[nbr][1]
		if new_speed > 0:
			set_speed(new_speed)
			label.set_visible_characters(0)
		else:
			if timer.is_processing():
				timer.stop()
			label.set_visible_characters(label.get_total_character_count())
		label.bbcode_text = dialog[nbr][0][index]
	elif dialog.size() >= nbr + 1:
		text_nbr += 1
		set_index(text_nbr, 0)
	else:
		emit_signal("text_finished")
	
	
func set_dialog(new_dialog):
	dialog = new_dialog