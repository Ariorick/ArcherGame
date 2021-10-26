extends Node2D
class_name CircularRaycastArray

const EnemyRaycastScene = preload("res://src/Enemy/Base/Sensors/EnemyRaycast.tscn")
const RAY_NUMBER := 16
const RAY_DISTANCE := 50.0

var rays: Array

func _ready():
	for i in range(0, RAY_NUMBER):
		var raycast = EnemyRaycastScene.instance()
		raycast.rotation = i * 2 * PI / RAY_NUMBER
		raycast.cast_to = Vector2(RAY_DISTANCE, 0)
		rays.append(raycast)
		add_child(raycast)

func _process(delta):
	update()

func get_directions() -> Array:
	var directions: Array
	for ray in rays:
		directions.append(get_direction(ray))
	return directions

func get_direction(raycast: RayCast2D) -> Direction:
	raycast.force_raycast_update()
	return Direction.new(
		raycast.rotation,
		get_distance(raycast),
		raycast.get_collider()
	)

func get_distance(raycast: RayCast2D) -> float:
	if raycast.is_colliding():
		return (raycast.get_collision_point() - raycast.global_position).length()
	else:
		return RAY_DISTANCE

func set_exceptions(exceptions):
	for ray in rays:
		add_exceptions(ray, exceptions)

func add_exceptions(raycast: RayCast2D, exceptions):
	for exception in exceptions:
		raycast.add_exception(exception)

func _draw():
#	Drawing.draw_directions(self, get_directions(), Color.white)
	pass
