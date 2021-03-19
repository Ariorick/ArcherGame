extends EnemyAction

const ATTACK_LENGTH = 600
const ATTACK_PAUSE = 700
const FULL_LENGTH = ATTACK_LENGTH + ATTACK_PAUSE

var target: Vector2

var started : = false
var landed : = false
var finished = false

var started_at = -10000


# override this
func want_to_start() -> bool:
	var elapsed_time = OS.get_ticks_msec() - started_at
	var can_start = elapsed_time > FULL_LENGTH
	return sensors.in_range && can_start

func perform():
	if not started:
		started = true
		target = sensors.target.global_position
		started_at = OS.get_ticks_msec()
		var distance = target - body.global_position
		body.linear_damp = 1
		body.apply_impulse(Vector2.ZERO, distance)
		animate_jump()
	
	var elapsed_time = OS.get_ticks_msec() - started_at
	
	if elapsed_time < ATTACK_LENGTH:
#		in air
		pass
	elif elapsed_time < FULL_LENGTH:
		if not landed:
			animate_landing()
			deal_damage()
			body.linear_damp = -1
			landed = true
	else :
		finished = true

func is_finished() -> bool:
	return finished

func is_interruptable() -> bool:
	return false

func cancel():
	started = false
	landed = false
	finished = false
	body.linear_damp = -1

func deal_damage():
	var bodies = $LandingAOE.get_overlapping_bodies()
	for body in bodies:
		body.take_damage()

func animate_jump():
	$AnimationPlayer.play("SkeletonJumpAttack")
	$AttackParticles2 .restart()
	$AttackParticles2.emitting = true
	$AttackParticles2.process_material.scale *= 0.5

func animate_landing():
	$AttackParticles.restart()
	$AttackParticles.emitting = true
	$AttackParticles2.process_material.scale *= 2
	$AttackParticles2.restart()
	$AttackParticles2.emitting = true
