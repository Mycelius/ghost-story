extends Control

var images = []
var cache
var tween

signal transition_complete
signal image_shown
signal image_hidden

func _ready():
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
	for i in range(images.size()):
		if (i != img_num):
			hide_image(img_num)
			yield(self, "image_hidden")
	images[img_num].show()
	fade_cache_out()
	yield(self, "transition_complete")
	emit_signal("image_shown")
	
	
func hide_image(var img_num):
	fade_cache_in()
	yield(self, "transition_complete")
	images[img_num].hide()
	emit_signal("image_hidden")

func fade_cache_in():
	tween.interpolate_property(cache, "color",
        Color(0,0,0,0), Color(0,0,0,1), 2,
        Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("transition_complete")
	
func fade_cache_out():
	tween.interpolate_property(cache, "color",
        Color(0,0,0,1), Color(0,0,0,0), 2,
        Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("transition_complete")