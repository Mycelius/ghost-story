extends Spatial

signal player_entered

func _ready():
	pass # Replace with function body.



func _on_Area_body_entered(body):
	if body.has_method("is_player"):
		emit_signal("player_entered")
