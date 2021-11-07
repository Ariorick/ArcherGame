extends EnemyAction
class_name NoPurposeAction

const REST_TIME = 2000
const RADIUS = 50

var start_time = -10000

# override this
func want_to_start() -> bool:
	return true

func perform():
	if mover.state == Mover.STATE.IDLE:
		if OS.get_ticks_msec() - start_time < REST_TIME:
			return
		
		start_time = OS.get_ticks_msec()
		var target_position = _select_search_target()
		mover.move_to(target_position, 2.0)

func _select_search_target() -> Vector2:
	var target
	var reachable = false
	var count = 0
	while not reachable:
		count += 1
		assert(count < 100, "ERROR: INFINITE_LOOP!")
		
		var direction = Random.direction(state.angle, PI / 2)
		
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
	return true

func cancel():
	mover.cancel()



