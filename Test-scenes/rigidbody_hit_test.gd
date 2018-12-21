extends RigidBody

const MULTIPLIER = 80

func _ready():
	pass

func power_hit(force, direction):
	
	apply_impulse(Vector3(0,0,0), direction * MULTIPLIER * force)