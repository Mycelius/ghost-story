extends Control

var cache
var tween
var is_showing

signal transition_complete

func _ready():
	cache = ColorRect.new()
	cache.rect_position = Vector2(0,0)
	cache.rect_size = Vector2(1280, 720)
	cache.color = Color(0,0,0,1)
	tween = Tween.new()
	add_child(tween)
	add_child(cache)
	
func show_cache():
	cache.color = Color(0,0,0,1)
	
func hide_cache():
	cache.color = Color(0,0,0,0)
	
func fade_out():
	tween.interpolate_property(cache, "color",
        Color(0,0,0,0), Color(0,0,0,1), 1,
        Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("transition_complete")
	
func fade_in():
	tween.interpolate_property(cache, "color",
        Color(0,0,0,1), Color(0,0,0,0), 1,
        Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("transition_complete")