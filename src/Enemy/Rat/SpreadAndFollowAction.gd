extends Action
class_name SpreadAndFollowAction

const SPEED = 90  # speed in pixels/sec

var target: Node2D
var other_enemies: Array

func _init(args: Dictionary, target: Node2D, other_enemies: Array).(args):
	self.target = target
	self.other_enemies = other_enemies

func perform():
	var direction_to_enemies : = Vector2()
	for enemy in other_enemies:
		direction_to_enemies += enemy.global_position - body.global_position
	direction_to_enemies = direction_to_enemies.normalized()
	var direction : = (target.global_position - body.global_position).normalized()
	var final_direction = (direction - direction_to_enemies * 0.3).normalized()
	
	var velocity = final_direction * SPEED
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
