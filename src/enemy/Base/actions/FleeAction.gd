extends EnemyAction
class_name FleeAction

const REST_TIME = 2000
const RADIUS = 150

var start_time = -10000

# override this
func want_to_start() -> bool:
	for actor in sensors.actors:
		if actor.get_intimidation() > state.size:
			return true
	return false

func perform():
	if mover.state == Mover.STATE.IDLE:
		var scary_actors := Array()
		for actor in sensors.actors:
			if actor.get_intimidation() > state.size:
				scary_actors.append(actor)
		
		var target_position = _select_flee_target(scary_actors)
		mover.move_to(target_position, 2.2, 2.0)


func _select_flee_target(scary_actors: Array) -> Vector2:
	var direction: Vector2
	for actor in scary_actors:
		direction += (actor.global_position - body.global_position)
	direction = -direction.normalized()
	
	var target
	var reachable = false
	var count = 0
	while not reachable:
		count += 1
		if count > 10:
			direction = Random.point_on_radius(1)
		assert(count < 100, "ERROR: INFINITE_LOOP!")
		
		var distance = RADIUS * pow(Random.f_range(0, 1), 0.25)
		target = navigation.get_closest_point(body.global_position + direction * distance)
		var path := navigation.get_simple_path(
			navigation.get_closest_point(body.global_position), 
			target)
		reachable = not path.empty()
		if not reachable:
			state.angle = Random.angle()
	return target

func is_finished() -> bool:
	return mover.state == Mover.STATE.FINISHED

func is_interruptable() -> bool:
	return false

func cancel():
	mover.cancel()



