extends Spatial

onready var Easing = preload("res://utils/easing.gd")

const ROTATION_DURATION = 1.0
const ROTATION_STEP = 90.0
export (float) var camera_distance
export (float) var camera_height

var rotation_offset
var pivot
var camera
var camera_rotation
var is_rotating
var rotation_dir
var rotation_time
var rotate_again

func _ready():
	rotation_offset = 0
	pivot = $pivot
	camera = $pivot/camera
	camera_rotation = 0
	is_rotating = false
	rotate_again = 0
	
	# Place the camera
	camera.transform.origin.z -= camera_distance
	camera.transform.origin.y += camera_height
	
	# Make the camera look at the pivot
	var lookDir = pivot.transform.origin - camera.transform.origin
	var cameraTransform = camera.transform.looking_at(lookDir, Vector3(0,1,0))
	camera.set_transform(cameraTransform)

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
	
	if (rotation_offset != 0 || rotate_again != 0) && !is_rotating:
		rotation_dir = rotation_offset if rotation_offset != 0 else rotate_again
		is_rotating = true
		rotation_time = 0
		camera_rotation = 0
		rotate_again = 0
	elif rotation_offset != 0 && is_rotating && rotation_time >= (ROTATION_DURATION * 0.5):
		rotate_again = rotation_offset
	
	if is_rotating:
		
		if rotation_time > ROTATION_DURATION:
			rotation_time = ROTATION_DURATION
		var laststep = camera_rotation
		camera_rotation = (Easing.Cubic.easeOut(rotation_time, 0.0, ROTATION_STEP, ROTATION_DURATION))
		
		if rotation_time == ROTATION_DURATION:
			is_rotating = false
		else:
			rotation_time += delta
		
		pivot.rotate_object_local(Vector3(0,1,0), deg2rad((camera_rotation - laststep) * rotation_dir))
	else:
		pivot.transform = pivot.transform.orthonormalized()
