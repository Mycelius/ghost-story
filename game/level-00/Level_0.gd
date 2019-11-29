extends Spatial

var seconds = 0

func _ready():
	$Timer.start()
	yield($Timer, "timeout")
	$Images.visible = 0
	