extends Node2D
class_name Mover

var last_force := Vector2.ZERO
var desires := Array() # of Desires
var modification_angle = Random.f_range(-PI/8, PI/8)
var noise := Noise.default()
var last_direction: Vector2 = Vector2.ZERO

var state = STATE.IDLE
enum STATE {
	IDLE,
	MOVING,
	FINISHED
}

export var preferred_distance: float = 30.0
export var distance_variation: float = 0.0
export var walk_force: float = 400.0

var target_node: Node2D
var target_position: Vector2
var desired_distance := 5.0

onready var body: RigidBody2D = get_parent().get_parent()
onready var sensors: Sensors = get_parent().get_node(NodePath("Sensors"))

func move_to(target_position: Vector2, desired_distance: float):
	self.target_position = target_position
	self.desired_distance = desired_distance
	state = STATE.MOVING

func chase(target_node: Node2D, desired_distance: float):
	self.target_node = target_node
	self.desired_distance = desired_distance
	state = STATE.MOVING

func cancel():
	state = STATE.IDLE
	body.add_force(Vector2.ZERO, -1 * last_force)
	last_force = Vector2.ZERO

func _physics_process(delta):
	if state == STATE.MOVING:
		_perform()
	update()

func _get_to_target() -> Vector2:
	if target_node != null:
		return target_node.global_position - body.global_position
	else:
		return target_position - body.global_position

func _perform():
	desires = Array()
	
	var smooth_random = noise.get_noise_1d(OS.get_ticks_msec() / 30)
	var follow_distance = preferred_distance + distance_variation * smooth_random
	
	var directions: Array = sensors.get_directions()
	for dir in directions:
		desires.append(Desire.new(dir.angle, dir.collider != null, dir.distance))
	
	var to_target = _get_to_target()
	
	if desired_distance > to_target.length():
		state = STATE.FINISHED
		return
	
	_add_dot_to_desires(to_target)
	
	for enemy in sensors.actors:
		var to_enemy = enemy.global_position - body.global_position
		var koef = -1 * clamp(1 / to_enemy.length(), 0, 0.2)
#		_add_dot_to_desires_evading(to_enemy, koef, modification_angle)
	
	
	desires = ArrayUtils.sort_by_func(desires, "get_total_desire")
	var top_desire = desires.back()

	var force = top_desire.get_direction() * walk_force
	
	body.add_force(Vector2.ZERO, -1 * last_force)
	body.add_force(Vector2.ZERO, force)
	last_force = force

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
		desire= weight * koef

func _draw():
	var vectors := Array()
	var red_vectors := Array()
	for desire in desires:
		if desire.has_obstacle:
			red_vectors.append(desire.get_direction() * desire.get_total_desire())
		else:
			vectors.append(desire.get_direction() * desire.get_total_desire())
	Drawing.draw_vectors_in_circle(self, 50, 50, vectors, Color.white, Color.white)
	Drawing.draw_vectors_in_circle(self, 50, 50, red_vectors, Color.red, Color.white)
	draw_line(Vector2.ZERO, _get_to_target(), Color.cyan)
	pass
