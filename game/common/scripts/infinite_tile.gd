extends Spatial

signal player_entered
signal player_exited
signal player_exited_level

func _ready():
	pass



func _on_Area_body_entered(body):
	if body.has_method("is_player"):
		emit_signal("player_entered")


func _on_Area_body_exited(body):
	if body.has_method("is_player"):
		emit_signal("player_exited")

func _on_ExitArea_body_entered(body):
	if body.has_method("is_player"):
		emit_signal("player_exited_level")
