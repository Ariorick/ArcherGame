extends Action
class_name JumpAttackAction

const ATTACK_LENGTH = 500
const ATTACK_PAUSE = 400
const ACTION_LENGTH = ATTACK_LENGTH + ATTACK_PAUSE

var target: Vector2

var started : = false
var landed : = false
var finished = false

var started_at = 0
var velocity: Vector2


func _init(args: Dictionary, target: Node2D).(args):
	self.target = target.global_position

func perform():
	if not started:
		started = true
		velocity = (target - body.global_position) / ATTACK_LENGTH * 1000
		started_at = OS.get_ticks_msec()
		animate_jump()
	
	var elapsed_time = OS.get_ticks_msec() - started_at
	
	if elapsed_time < ATTACK_LENGTH:
		body.move_and_slide(velocity)
	elif elapsed_time < ATTACK_LENGTH + ATTACK_PAUSE:
		if not landed:
			animate_landing()
			deal_damage()
			landed = true
	else :
		finished = true

func deal_damage():
	var bodies = $LandingAOE.get_overlapping_bodies()
	for body in bodies:
		body.take_damage()

func animate_jump():
	$AnimationPlayer.play("SkeletonJumpAttack")
	$AttackParticles2.restart()
	$AttackParticles2.emitting = true
	$AttackParticles2.process_material.scale *= 0.5

func animate_landing():
	$AttackParticles.restart()
	$AttackParticles.emitting = true
	$AttackParticles2.process_material.scale *= 2
	$AttackParticles2.restart()
	$AttackParticles2.emitting = true


func is_finished() -> bool:
	return finished

func is_interruptable() -> bool:
	return false
