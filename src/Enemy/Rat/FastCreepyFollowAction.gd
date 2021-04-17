extends EnemyAction
class_name FastCreepyFollowAction

const WALK_FORCE = 600
var last_walk_force := Vector2.ZERO

# override this
func want_to_start() -> bool:
	return sensors.target != null

func perform():
	body.add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
	
	var walk_force = (sensors.target.global_position - body.global_position).normalized() * WALK_FORCE
	if walk_force.length() > 0:
		$AnimationPlayer.play("Walk")
		$StepParticles.emitting = true
	
	body.add_force(Vector2.ZERO, walk_force)
	last_walk_force = walk_force

func is_finished() -> bool:
	return sensors.target == null

func is_interruptable() -> bool:
	return true

# override this
func cancel():
	body.add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
	$StepParticles.emitting = false

