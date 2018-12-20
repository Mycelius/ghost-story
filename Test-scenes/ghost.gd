extends KinematicBody

export (float) var speed = 7.00
export (float) var gravity = -9.80
export (float) var acceleration = 5.00
export (float) var deceleration = 7.00
export (bool) var has_move_power = false

const MAX_MOVE_POWER = 5

var move_power = 0
var timer

var direction = Vector3()
var velocity = Vector3()
var is_moving = false
var is_charging = false

var player_axes

func _init():
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_IDLE)
	timer.connect("timeout", self, "_charge")
	add_child(timer)

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
	if has_move_power && Input.is_action_just_pressed("ui_select"):
		start_charging()
		is_charging = true
	if has_move_power && Input.is_action_just_released("ui_select"):
		release_power()
		is_charging = false
		
		
func move_process(delta):
	# Moving player
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
	# Rotating player
	if is_moving:
		var angle = atan2(hv.x, hv.z)
		var char_rot = get_rotation()
		
		char_rot.y = angle
		set_rotation(char_rot)

func start_charging():
	_charge()
	timer.set_wait_time(0.5)
	timer.start()

func _charge():
	if move_power < MAX_MOVE_POWER:
		move_power += 0.5
		print(move_power)

func release_power():
	var power = $Power
	power.force_raycast_update()
	if power.is_colliding():
		var body = power.get_collider()
		if body.has_method("power_hit"):
			body.power_hit(move_power, power.get_collision_point())
	timer.stop()
	move_power = 0
	
func is_player():
	return true