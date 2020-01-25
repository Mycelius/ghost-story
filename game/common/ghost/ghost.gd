extends KinematicBody

export (float) var speed = 7.00
export (float) var speed_while_charge = 3.00
export (float) var gravity = -9.80
export (float) var acceleration = 5.00
export (float) var deceleration = 7.00
export (bool) var has_move_power = true
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
var idle_move = 0
var falling_value = 0
var charging_value = 0

var is_releasing_force = false
var animation_change_speed = 5.00

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
	# Direction du joueur normalisée
	direction = direction.normalized()
	
	# Check if is falling
	is_falling = false
	if (! is_on_floor() && velocity.y < 0.01):
		is_falling = true
	# Effet de la gravité
	velocity.y += gravity * delta
	
	# Copier vecteur de vélocité en supprimant la composante verticale
	var hv = velocity
	hv.y = 0
	
	# Calculer la nouvelle position du joueur
	var new_pos
	if ! is_charging:
		new_pos = direction * speed
	else:
		new_pos = direction * speed_while_charge
	
	# déterminer si le joueur accélère ou décélère en comparant la direction et la vélocité
	var accel = deceleration
	if (direction.dot(hv) > 0):
		accel = acceleration
	
	# Adapter le vecteur de vélocité horizontal en tenant compte de l'accélération
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	# remplacer les valeurs du vecteur de vélocité général par celles de vélocité horizontale
	velocity.x = hv.x
	velocity.z = hv.z
	
	# Déplacer le joueur
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	# Rotating player
	if is_moving:
		var angle = atan2(hv.x, hv.z)
		var char_rot = get_rotation()
		char_rot.y = angle
		set_rotation(char_rot)
		
	# Set animation to play
	# Amount of falling animation
	if (is_falling && falling_value < 1):
		falling_value += delta * animation_change_speed
	elif (! is_falling && falling_value > 0) :
		falling_value -= delta * animation_change_speed
	
	# Charging animation
	if (is_charging && charging_value < 1):
		charging_value += delta * animation_change_speed
	elif (! is_charging && charging_value > 0) :
		charging_value -= delta * animation_change_speed
		
	animationTree.set("parameters/Charge_blend/blend_amount", charging_value)
	
	idle_move = (hv.length() / speed) - falling_value
	animationTree.set("parameters/Positions/blend_position", Vector2(idle_move, falling_value))
	
		
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
		#print(move_power)

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