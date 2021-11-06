extends EnemyAction
class_name NoPurposeAction

const RADIUS = 40

# override this
func want_to_start() -> bool:
	return true

func perform():
	if mover.state == Mover.STATE.IDLE:
		mover.move_to(body.global_position + _select_search_target(), 5.0)

func _select_search_target() -> Vector2:
	var target
	var reachable = false
	var count = 0
	while not reachable:
		count += 1
		assert(count < 100, "ERROR: INFINITE_LOOP!")
		
		var direction = Random.direction(state.angle, PI / 3)
		var distance = RADIUS * pow(Random.f_range(0, 1), 0.25)
		target = state.position + direction * distance
		reachable = true
#		reachable = can_spawn_here_ref.call_func(target)
#		if not reachable:
#			state.angle = Random.angle()
	return target

func is_finished() -> bool:
	return mover.state == Mover.STATE.FINISHED

func is_interruptable() -> bool:
	return true

func cancel():
	mover.cancel()



