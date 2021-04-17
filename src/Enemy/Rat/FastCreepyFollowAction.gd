extends EnemyAction
class_name FastCreepyFollowAction

const WALK_FORCE = 700
const RANDOM_OFFSET = 10

var last_walk_force := Vector2.ZERO
var offset_from_target: Vector2
var started = false

# override this
func want_to_start() -> bool:
	return sensors.target != null

func perform():
	if not started:
		started = true
		offset_from_target = Random.point_on_radius(10)
	
	body.add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
	
	var desired_position = sensors.target.global_position + offset_from_target
	
	var walk_force = ( - body.global_position).normalized() * WALK_FORCE
	if walk_force.length() > 0:
		$AnimationPlayer.play("Walk")
#		$StepParticles.emitting = true
	
	body.add_force(Vector2.ZERO, walk_force)
	last_walk_force = walk_force

func is_finished() -> bool:
	return sensors.target == null

func is_interruptable() -> bool:
	return true

# override this
func cancel():
	started = false
	body.add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
#	$StepParticles.emitting = false

