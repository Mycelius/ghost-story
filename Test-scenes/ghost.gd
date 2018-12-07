extends KinematicBody

export var speed = 7
export var gravity = -9.8
export var acceleration = 5
export var deceleration = 7

var direction = Vector3()
var velocity = Vector3()
var is_moving = false

var player_axes

func _ready():
	player_axes = get_parent().get_node("camera-system/pivot/player-direction")

func _physics_process(delta):
	keyboard_process()
	move_process(delta)
	
func keyboard_process():
	direction = Vector3(0,0,0)
	var abs_direction = player_axes.get_global_transform().basis
	is_moving = false
	if Input.is_action_pressed("ui_up"):
		direction += abs_direction.z
		is_moving = true
	if Input.is_action_pressed("ui_down"):
		direction -= abs_direction.z
		is_moving = true
	if Input.is_action_pressed("ui_left"):
		direction += abs_direction.x
		is_moving = true
	if Input.is_action_pressed("ui_right"):
		direction -= abs_direction.x
		is_moving = true
		
		
func move_process(delta):
	direction = direction.normalized()
	
	velocity.y += gravity * delta
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = direction * speed
	var accel = deceleration
	
	if (direction.dot(hv) > 0):
		accel = acceleration
	
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if is_moving:
		var angle = atan2(hv.x, hv.z)
		var char_rot = get_rotation()
		
		char_rot.y = angle
		set_rotation(char_rot)
		
func is_player():
	return true