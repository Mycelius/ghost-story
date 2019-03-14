extends Spatial

const ROTATION_DURATION = 1.0
const ROTATION_STEP = 90.0
export (float) var camera_distance
export (float) var camera_height

var player_position

var rotation_offset
var pivot
var camera
var camera_rotation
var is_rotating
var tween

func _ready():
	rotation_offset = 0
	pivot = $pivot
	camera = $pivot/camera
	camera_rotation = 0
	is_rotating = false
	tween = get_node("Tween")
	
	# Place the camera
	camera.transform.origin.z -= camera_distance
	camera.transform.origin.y += camera_height
	
	# Make the camera look at the pivot
	var lookDir = pivot.transform.origin - camera.transform.origin
	var cameraTransform = camera.transform.looking_at(lookDir, Vector3(0,1,0))
	camera.set_transform(cameraTransform)
	

func _process(delta):
	process_input()
	process_move()
	
func process_input():
	rotation_offset = 0
	if Input.is_action_just_pressed("camera_left"):
		rotation_offset -= 1
	elif Input.is_action_just_pressed("camera_right"):
		rotation_offset += 1
	rotate_camera(rotation_offset)
		
func process_move():
	## Follow player
	#get player position
	if get_parent().get_node("ghost"):
		player_position = get_parent().get_node("ghost").global_transform.origin
		pivot.global_transform.origin = player_position
	
func rotate_camera(rotation_offset):
	if rotation_offset != 0 && !is_rotating:
		is_rotating = true
		tween.interpolate_property(pivot, "rotation_degrees", 
			pivot.rotation_degrees, 
			Vector3(0,pivot.rotation_degrees.y + (ROTATION_STEP * rotation_offset),0), 
			ROTATION_DURATION, 
			Tween.TRANS_QUAD,
			Tween.EASE_IN_OUT)
		tween.start()

func _camera_rotation_complete(object, key):
	pivot.transform = pivot.transform.orthonormalized()
	is_rotating = false
