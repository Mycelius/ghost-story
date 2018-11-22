extends KinematicBody

export var speed = 200
export var gravity = -9.8

var direction = Vector3()
var velocity = Vector3()

func _ready():
	pass

func _physics_process(delta):
	keyboard_process()
	move_process(delta)
	
func keyboard_process():
	direction = Vector3(0,0,0)
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		
		
func move_process(delta):
	direction = direction.normalized()
	direction = direction * speed * delta
	
	velocity.y += gravity * delta
	velocity.x = direction.x
	velocity.z = direction.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	