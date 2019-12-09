extends Control

var images = []
var cache
var tween
var is_showing

signal transition_complete
signal image_shown
signal image_hidden
signal viewer_hidden

func _ready():
	is_showing = null
	images = get_children()
	cache = ColorRect.new()
	cache.rect_position = Vector2(0,0)
	cache.rect_size = Vector2(1280, 720)
	cache.color = Color(0,0,0,1)
	tween = Tween.new()
	add_child(tween)
	add_child(cache)
	move_child(cache, get_child_count())

func show_image(var img_num):
	if (is_showing != img_num && is_showing != null):
		hide_image(is_showing)
		yield(self, "image_hidden")
	images[img_num].show()
	is_showing = img_num
	fade_cache_out()
	yield(self, "transition_complete")
	emit_signal("image_shown")
	
	
func hide_image(var img_num):
	fade_cache_in()
	yield(self, "transition_complete")
	images[img_num].hide()
	is_showing = null
	emit_signal("image_hidden")

func fade_cache_in():
	tween.interpolate_property(cache, "color",
        Color(0,0,0,0), Color(0,0,0,1), 1,
        Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("transition_complete")
	
func fade_cache_out():
	tween.interpolate_property(cache, "color",
        Color(0,0,0,1), Color(0,0,0,0), 1,
        Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("transition_complete")
	
func hide():
	fade_cache_out()
	yield(self, "transition_complete")
	visible = false
	emit_signal("viewer_hidden")