extends EnemyAction
class_name NoPurposeAction

const RADIUS = 100

# override this
func want_to_start() -> bool:
	return true

func perform():
	if mover.state == Mover.STATE.IDLE:
		var target_position = _select_search_target()
		mover.move_to(target_position, 16.0)

func _select_search_target() -> Vector2:
	var target
	var reachable = false
	var count = 0
	var path
	while not reachable:
		count += 1
		assert(count < 100, "ERROR: INFINITE_LOOP!")
		
		var direction = Random.direction(state.angle, PI / 3)
		
		var distance = RADIUS * pow(Random.f_range(0, 1), 0.25)
		target = navigation.get_closest_point(body.global_position + direction * distance)
		path = navigation.get_simple_path(
			navigation.get_closest_point(body.global_position), 
			target)
		reachable = not path.empty()
		if not reachable:
			state.angle = Random.angle()
	return target

func is_finished() -> bool:
	return mover.state == Mover.STATE.FINISHED

func is_interruptable() -> bool:
	return true

func cancel():
	mover.cancel()



