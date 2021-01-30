extends Action
class_name BiteAttackAction

const ATTACK_LENGTH_PX = 50

const PREPARATION_TIME = 600
const ATTACK_TIME = 200
const PAUSE_AFTER_ATTACK = 300
const ACTION_LENGTH = PREPARATION_TIME + ATTACK_TIME + PAUSE_AFTER_ATTACK

var target: Node2D

var started : = false
var landed : = false
var finished = false

var started_at = 0
var velocity: Vector2 = Vector2.ZERO


func _init(args: Dictionary, target: Node2D).(args):
	self.target = target

func perform():
	if not started:
		started = true
		started_at = OS.get_ticks_msec()
		animate_preparation()
	
	var elapsed_time = OS.get_ticks_msec() - started_at
	
	if elapsed_time < PREPARATION_TIME:
		return
	elif elapsed_time < PREPARATION_TIME + ATTACK_TIME:
		if velocity == Vector2.ZERO:
			var direction = (target.global_position - body.global_position).normalized()
			velocity = direction * ATTACK_LENGTH_PX / ATTACK_TIME * 1000
			animate_jump()
		body.move_and_slide(velocity)
		if not landed:
			animate_landing()
			deal_damage()
			landed = true
	elif elapsed_time < ACTION_LENGTH:
		return
	else:
		finished = true

func deal_damage():
	var bodies = $LandingAOE.get_overlapping_bodies()
	for body in bodies:
		body.take_damage()

func animate_preparation():
	$AnimationPlayer.play("BiteAttack")

func animate_jump():
	$AttackParticles2.restart()
	$AttackParticles2.emitting = true
#	$AttackParticles2.process_material.scale *= 0.5

func animate_landing():
	pass
#	$AttackParticles.restart()
#	$AttackParticles.emitting = true
#	$AttackParticles2.process_material.scale *= 2
#	$AttackParticles2.restart()
#	$AttackParticles2.emitting = true


func is_finished() -> bool:
	return finished

func is_interruptable() -> bool:
	return false
