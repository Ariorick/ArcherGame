extends Area2D
class_name FireProjectile

const SPEED = 1
const CORRECTION_SPEED = 0.05
const MAX_LIFETIME = 5

var target: PhysicsBody2D
var direction : Vector2
onready var creation_time = OS.get_ticks_msec()

func _physics_process(delta):
	direction = direction.linear_interpolate((target.global_position - global_position).normalized(), get_correction_speed())
	direction = direction.normalized()
	global_position += direction * SPEED
	if get_lifetime_sec() > MAX_LIFETIME:
		queue_free()

func set_target(target: PhysicsBody2D):
	self.target = target
	direction = (target.global_position - global_position).normalized()
	
func get_correction_speed() -> float:
	var lifetime = get_lifetime_sec() + 1.0
	return min(1, CORRECTION_SPEED / pow(lifetime, 1.2))

func get_lifetime_sec():
	return (OS.get_ticks_msec() - creation_time) / 1000
