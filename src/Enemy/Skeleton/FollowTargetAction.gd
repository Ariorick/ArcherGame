extends Action
class_name FollowTargetAction

const WALK_FORCE = 500
var last_walk_force := Vector2.ZERO

var target: Node2D

func _init(args: Dictionary, target: Node2D).(args):
	self.target = target

func perform():
	body.add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
	
	var walk_force = (target.global_position - body.global_position).normalized() * WALK_FORCE
	if walk_force.length() > 0:
		$AnimationPlayer.play("Walk")
		$StepParticles/Left.emitting = true
		$StepParticles/Right.emitting = true
	
	body.add_force(Vector2.ZERO, walk_force)
	last_walk_force = walk_force
	
#	body.move_and_slide(velocity)

func interrupt():
	body.add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
	$StepParticles/Left.emitting = false
	$StepParticles/Right.emitting = false

func is_finished() -> bool:
	return false

func is_interruptable() -> bool:
	return true
