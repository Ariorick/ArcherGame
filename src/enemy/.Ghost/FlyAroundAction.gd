extends EnemyAction
class_name FlyAroundAction

const WALK_FORCE = 90
var last_walk_force := Vector2.ZERO

func _ready():
	$AnimationPlayer.play("Fly")

# override this
func want_to_start() -> bool:
	return sensors.target != null

func perform():
	body.add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
	
	var walk_force = (sensors.target.global_position - body.global_position).normalized() * WALK_FORCE
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

