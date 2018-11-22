extends KinematicBody

export var speed = 7
export var gravity = -9.8
export var acceleration = 5
export var deceleration = 7

var direction = Vector3()
var velocity = Vector3()
var is_moving = false

func _ready():
	pass

func _physics_process(delta):
	keyboard_process()
	move_process(delta)
	
func keyboard_process():
	direction = Vector3(0,0,0)
	is_moving = false
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
		is_moving = true
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
		is_moving = true
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		is_moving = true
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
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