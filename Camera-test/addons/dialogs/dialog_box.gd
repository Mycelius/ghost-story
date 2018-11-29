tool
extends Control

var scene

func _enter_tree():
	scene = preload("res://addons/dialogs/dialogs.tscn")
	scene = scene.instance()
	add_child(scene)