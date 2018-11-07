extends Spatial

var rotation_offset
var pivot

func _ready():
	rotation_offset = 0
	pivot = $pivot

func _process(delta):
	process_input()
	process_move(delta)
	
func process_input():
	rotation_offset = 0
	if Input.is_action_just_pressed("camera_left"):
		rotation_offset -= 1
	elif Input.is_action_just_pressed("camera_right"):
		rotation_offset += 1
		
func process_move(delta):
	if rotation_offset != 0:
		var camera_rotation = (PI / 2) * rotation_offset
		pivot.rotate_object_local(Vector3(0,1,0), camera_rotation)