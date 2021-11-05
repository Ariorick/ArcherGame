extends EnemyAction
class_name FireMagicAction

const FireProjectile = preload("res://src/enemy/Mage/FireProjectile.tscn")

const CHARGE_LENGTH = 700
const COOLDOWN_LENGT = 700
const FULL_LENGTH = CHARGE_LENGTH + COOLDOWN_LENGT
const PREFERRED_DISTANCE = 50
const DISTANCE_TRESHOLD = 10

var started : = false
var fired : = false
var finished = false

var started_at = -10000


# override this
func want_to_start() -> bool:
	var elapsed_time = OS.get_ticks_msec() - started_at
	var can_start = elapsed_time > FULL_LENGTH
	print(distance_to_target())
	return sensors.in_range and can_start and distance_is_in_treshold()

func perform():
	if not started:
		# start charging
		started_at = OS.get_ticks_msec()
		started = true
		$AnimationPlayer.play("ChargeFire")

	
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
	return finished or sensors.target == null

func is_interruptable() -> bool:
	return false

func cancel():
	started = false
	fired = false
	finished = false

func create_projectile():
	var fire = FireProjectile.instance()
	fire.global_position = body.global_position + Vector2(0, -6)
	body.get_parent().add_child(fire)

func distance_is_in_treshold() -> bool:
	return is_in_treshold(distance_to_target(), PREFERRED_DISTANCE, DISTANCE_TRESHOLD)

func distance_to_target() -> float:
	return sensors.target.global_position.distance_to(body.global_position)

func is_in_treshold(value, compared_value, treshold) -> bool:
	return value < compared_value + treshold and value > compared_value - treshold
