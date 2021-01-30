extends Action
class_name FollowTargetAction

const SPEED = 80  # speed in pixels/sec

var target: Node2D

func _init(args: Dictionary, target: Node2D).(args):
	self.target = target

func perform():
	var velocity = (target.global_position - body.global_position).normalized() * SPEED
	if velocity.length() > 0:
		$AnimationPlayer.play("Walk")
		$StepParticles/Left.emitting = true
		$StepParticles/Right.emitting = true
	body.move_and_slide(velocity)

func interrupt():
	$StepParticles/Left.emitting = false
	$StepParticles/Right.emitting = false

func is_finished() -> bool:
	return false

func is_interruptable() -> bool:
	return true
