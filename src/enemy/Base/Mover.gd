extends Node2D
class_name Mover

const STUCK_DISTANCE := 16

export var preferred_distance: float = 30.0
export var distance_variation: float = 0.0
export var walk_force: float = 400.0

var last_force := Vector2.ZERO
var desires := Array() # of Desires
#var modification_angle = Random.f_range(-PI/8, PI/8)
var noise := Noise.default()
#var last_direction: Vector2 = Vector2.ZERO

var recent_position = null # to check if stuck
var recent_position_remember_time = 0.0

var initial_position: Vector2
var initial_path: PoolVector2Array
var path: PoolVector2Array
var state = STATE.IDLE
enum STATE {
	IDLE,
	MOVING,
	FINISHED
}

var target_node: Node2D
var target_position: Vector2
var desired_distance := 5.0

onready var body: RigidBody2D = get_parent().get_parent()
onready var enemy_state: EnemyState = get_parent().get_node(NodePath("EnemyState"))
onready var sensors: Sensors = get_parent().get_node(NodePath("Sensors"))
onready var navigation: Navigation2D = body.get_parent().get_parent().get_node(NodePath("Navigation2D"))

func move_to(target_position: Vector2, desired_distance: float):
	self.target_position = target_position
	start(desired_distance)

func chase(target_node: Node2D, desired_distance: float):
	self.target_node = target_node
	start(desired_distance)

func start(desired_distance: float):
	self.desired_distance = desired_distance
	state = STATE.MOVING
	path = navigation.get_simple_path(body.global_position, _get_target())
	initial_path = path
	initial_position = body.global_position
	

func cancel():
	target_node = null
	path = PoolVector2Array()
	state = STATE.IDLE
	body.add_force(Vector2.ZERO, -1 * last_force)
	last_force = Vector2.ZERO

func _process(delta):
	update()

func _physics_process(delta):
	if state == STATE.MOVING:
		_perform()

func _get_target() -> Vector2:
	if target_node != null:
		return target_node.global_position
	else:
		return target_position

func _get_to_target() -> Vector2:
	return _get_target() - body.global_position

func _perform():
	desires = Array()
	
#	var smooth_random = noise.get_noise_1d(OS.get_ticks_msec() / 30)
#	var follow_distance = preferred_distance + distance_variation * smooth_random
#
#	var directions: Array = sensors.get_directions()
#	for dir in directions:
#		desires.append(Desire.new(dir.angle, dir.collider != null, dir.distance))
#
	var to_target = _get_to_target()
	
	if desired_distance > to_target.length():
		state = STATE.FINISHED
		return
	
	_remember_position()
	if _is_stuck():
		enemy_state.angle = Random.angle()
		state = STATE.FINISHED
		recent_position = null
		return
	
	var direction_along_path = _direction_along_path(body.global_position, desired_distance)
	
#	_add_dot_to_desires(direction_along_path)
#
#	for enemy in sensors.actors:
#		var to_enemy = enemy.global_position - body.global_position
#		var koef = -1 * clamp(1 / to_enemy.length(), 0, 0.2)
#		_add_dot_to_desires_evading(to_enemy, koef, modification_angle)
#
#
#	desires = ArrayUtils.sort_by_func(desires, "get_total_desire")
#	var top_desire = desires.back()
#
#	var force = top_desire.get_direction() * walk_force
	var force = walk_force * direction_along_path
	
	body.add_force(Vector2.ZERO, -1 * last_force)
	body.add_force(Vector2.ZERO, force)
	enemy_state.angle = force.angle()
	last_force = force

func _direction_along_path(current_position: Vector2, distance : float) -> Vector2:
	var last_point : = current_position
	var approx := 2.0 # px
	for index in path.size():
		var distance_to_next = last_point.distance_to(path[0])
		# if we won't reach the point on this frame
		if distance <= distance_to_next and distance > 0.0:
			last_point = last_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		# if we can finish move
		elif path.size() == 1 and distance >= distance_to_next:
			last_point = path[0]
			path.remove(0)
			break

		distance -= distance_to_next
		last_point = path[0]
		path.remove(0)
	return (last_point - current_position).normalized()

func _add_dot_to_desires(vector: Vector2, modify_angle: float = 0.0):
	for i in desires.size():
		var desire = desires[i]
		var oposite_desire = desires[(i + desires.size()) % desires.size()]
		var v = vector.normalized().rotated(modify_angle)
		var value = v.dot(desire.get_direction())
#		desire.target_desire = abs(value)
		if value > 0:
			desire.target_desire += value

func _add_dot_to_desires_evading(vector: Vector2, koef: float, modify_angle: float = 0.0):
	for desire in desires:
		var v = vector.normalized().rotated(modify_angle)
		var dot = v.dot(desire.get_direction())
		var weight = 1.0 - abs(dot - 0.65)
		desire = weight * koef

func _remember_position():
	if recent_position == null or (body.global_position - recent_position).length() > STUCK_DISTANCE:
		recent_position = body.global_position
		recent_position_remember_time = OS.get_ticks_msec()

func _is_stuck() -> bool:
	if recent_position == null:
		return false
	var elapced = OS.get_ticks_msec() - recent_position_remember_time
	return elapced > 3000 and (body.global_position - recent_position).length() < STUCK_DISTANCE

func _draw():
	# VECTORS
#	var vectors := Array()
#	var red_vectors := Array()
#	for desire in desires:
#		if desire.has_obstacle:
#			red_vectors.append(desire.get_direction() * desire.get_total_desire())
#		else:
#			vectors.append(desire.get_direction() * desire.get_total_desire())
#	Drawing.draw_vectors_in_circle(self, 50, 50, vectors, Color.white, Color.white)
#	Drawing.draw_vectors_in_circle(self, 50, 50, red_vectors, Color.red, Color.white)
#
	# NAVIGATION
#	var transition_path = PoolVector2Utils.add_vector_to_path(initial_path, -global_position)
#	transition_path.insert(0, initial_position - body.global_position)
#	if state == STATE.MOVING:
#		draw_polyline(transition_path, Color.cyan, 1)
#	for i in transition_path.size() - 1:
#		draw_circle(transition_path[i], 2, Color.cyan)
#	draw_circle(target_position - global_position, 3, Color.cyan)
	pass
