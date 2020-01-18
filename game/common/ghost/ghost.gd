extends KinematicBody

export (float) var speed = 7.00
export (float) var gravity = -9.80
export (float) var acceleration = 5.00
export (float) var deceleration = 7.00
export (bool) var has_move_power = false
export (bool) var has_stairs_power = false
export (int) var max_move_power = 5

var move_power = 0
var stairs_power = false
var timer
var animationTree

var direction = Vector3()
var velocity = Vector3()
var is_moving = false
var is_charging = false
var is_falling = false
var is_releasing_force = false

var player_axes

func _init():
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_IDLE)
	timer.connect("timeout", self, "_charge")
	add_child(timer)
	

func _ready():
	player_axes = get_parent().get_node("camera-system/pivot/player-direction")
	animationTree = $AnimationTree

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
	if has_stairs_power && Input.is_action_just_pressed("stairs_switch"):
		switch_stairs()
		
		
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
		
	# Set animation to play
	animationTree.set("parameters/Idle_move/blend_amount", hv.length() / speed)
	
		
func switch_stairs():
	var stairs_light = $StairsLight
	if stairs_power:
		stairs_light.hide()
		set_collision_mask_bit(2,false)
		stairs_power = false
	else:
		var stairs_test = $Stairs_test_area
		if stairs_test.get_overlapping_bodies().size() == 0:
			stairs_light.show()
			set_collision_mask_bit(2,true)
			stairs_power = true

func start_charging():
	_charge()
	timer.set_wait_time(0.5)
	timer.start()

func _charge():
	if move_power < max_move_power:
		move_power += 0.5
		print(move_power)

func release_power():
	var power = $Power_area
	var hitobjects = power.get_overlapping_bodies()
	for ob in hitobjects:
		if ob.has_method("power_hit"):
			var direction = get_global_transform().basis.z.normalized()
			ob.power_hit(move_power, direction)
	timer.stop()
	move_power = 0
	
func is_player():
	return true