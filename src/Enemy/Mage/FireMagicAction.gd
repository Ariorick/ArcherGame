extends EnemyAction
class_name FireMagicAction

const FireProjectile = preload("res://src/Enemy/Mage/FireProjectile.tscn")

const CHARGE_LENGTH = 700
const COOLDOWN_LENGT = 700
const FULL_LENGTH = CHARGE_LENGTH + COOLDOWN_LENGT

var started : = false
var fired : = false
var finished = false

var started_at = -10000


# override this
func want_to_start() -> bool:
	var elapsed_time = OS.get_ticks_msec() - started_at
	var can_start = elapsed_time > FULL_LENGTH
	return sensors.in_range && can_start

func perform():
	if not started:
		# start charging
		started_at = OS.get_ticks_msec()
		started = true

	
	var elapsed_time = OS.get_ticks_msec() - started_at
	
	if elapsed_time < CHARGE_LENGTH:
		# continue charging
		pass
	elif elapsed_time < FULL_LENGTH:
		# fire
		if not fired:
			var target_pos = sensors.target.global_position
			var direction = (target_pos - body.global_position).normalized()
			body.apply_impulse(Vector2.ZERO, direction * -15)
			create_projectile()
			fired = true
	else:
		finished = true

func is_finished() -> bool:
	return finished

func is_interruptable() -> bool:
	return false

func cancel():
	started = false
	fired = false
	finished = false

func create_projectile():
	var fire = FireProjectile.instance()
	body.get_parent().add_child(fire)
	fire.global_position = body.global_position
	fire.set_target(sensors.target)
