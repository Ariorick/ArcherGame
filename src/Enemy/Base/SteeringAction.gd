extends EnemyAction
class_name SteeringAction

const PREFERRED_DISTANCE = 50
const TRESHOLD = 5
const START_TRESHOLD = 10

const WALK_FORCE = 100
var last_walk_force := Vector2.ZERO

# override this
func want_to_start() -> bool:
	return sensors.target != null and out_of_treshold(distance_to_target(), PREFERRED_DISTANCE, START_TRESHOLD)

func perform():
	body.add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
	
	var direction = (sensors.target.global_position - body.global_position).normalized()
	var corrected_direction = direction * sign(distance_to_target() - PREFERRED_DISTANCE)
	var walk_force = corrected_direction * WALK_FORCE
	
	if walk_force.length() > 0:
		$AnimationPlayer.play("Walk")
		$StepParticles.emitting = true
	
	body.add_force(Vector2.ZERO, walk_force)
	last_walk_force = walk_force

func is_finished() -> bool:
	return sensors.target == null or is_in_treshold(distance_to_target(), PREFERRED_DISTANCE, TRESHOLD)

func is_interruptable() -> bool:
	return true

# override this
func cancel():
	body.add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
	$StepParticles.emitting = false

func is_in_treshold(value, compared_value, treshold) -> bool:
	return value < compared_value + treshold or value > compared_value - treshold

func out_of_treshold(value, compared_value, treshold) -> bool:
	return value > compared_value + treshold or value < compared_value - treshold

func distance_to_target() -> float:
	return sensors.target.global_position.distance_to(body.global_position)

