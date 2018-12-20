extends RigidBody

const MULTIPLIER = 80

func _ready():
	pass

func power_hit(force, collision_point):
	var direction_vect = global_transform.origin - collision_point
	direction_vect = direction_vect.normalized()
	
	apply_impulse(collision_point, direction_vect * MULTIPLIER * force)