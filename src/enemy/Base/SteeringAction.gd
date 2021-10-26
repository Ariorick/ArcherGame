extends EnemyAction
class_name SteeringAction

var last_force := Vector2.ZERO
var desires := Dictionary()
var modification_angle = Random.f_range(-PI/8, PI/8)
var noise := Noise.default()
var last_direction: Vector2 = Vector2.ZERO

export var preferred_distance: float = 30.0
export var distance_variation: float = 20.0
export var walk_force: float = 600.0

# override this
func want_to_start() -> bool:
	return sensors.target != null

func perform():
	update()
	desires = Dictionary()
	
	var smooth_random = noise.get_noise_1d(OS.get_ticks_msec() / 30)
	var follow_distance = preferred_distance + distance_variation * smooth_random
	
	var directions: Array = sensors.get_directions()
	for dir in directions:
		desires[dir] = 0.0
	
	var to_target = (sensors.target.global_position - body.global_position)
	var koef = clamp(to_target.length() / follow_distance - 1, -1, 1)
	add_dot_to_desires(to_target, koef)
	
	for enemy in sensors.other_enemies:
		var to_enemy = enemy.global_position - body.global_position
		koef = -1 * clamp(1 / to_enemy.length(), 0, 0.2)
		add_dot_to_desires_evading(to_enemy, koef, modification_angle)
	
	
	var best_direction := Vector2.ZERO
	var most_desire := -100.0
	for dir in desires.keys():
		if desires[dir] > most_desire:
			best_direction = dir.get_direction()
			most_desire = desires[dir]
	
	
#	if most_desire < 0.2:
#		best_direction = last_direction
#	last_direction = best_direction
	
	var desire = clamp(most_desire * 3, 0, 1)
	var force = desire * best_direction * walk_force
	
	body.add_force(Vector2.ZERO, -1 * last_force)
	body.add_force(Vector2.ZERO, force)
	last_force = force

func add_dot_to_desires(vector: Vector2, koef: float, modify_angle: float = 0.0):
	for dir in desires.keys():
		var v = vector.normalized().rotated(modify_angle)
		desires[dir] += v.dot(dir.get_direction()) * koef

func add_dot_to_desires_evading(vector: Vector2, koef: float, modify_angle: float = 0.0):
	for dir in desires.keys():
		var v = vector.normalized().rotated(modify_angle)
		var dot = v.dot(dir.get_direction())
		var weight = 1.0 - abs(dot - 0.65)
		desires[dir] += weight * koef

func is_finished() -> bool:
	return sensors.target == null

func is_interruptable() -> bool:
	return true

# override this
func cancel():
	body.add_force(Vector2.ZERO, -1 * last_force)
	last_force = Vector2.ZERO

func is_in_treshold(value, compared_value, treshold) -> bool:
	return value < compared_value + treshold or value > compared_value - treshold

func out_of_treshold(value, compared_value, treshold) -> bool:
	return value > compared_value + treshold or value < compared_value - treshold

func distance_to_target() -> float:
	return sensors.target.global_position.distance_to(body.global_position)

func _draw():
	var vectors := Array()
	for dir in desires.keys():
		vectors.append(dir.get_direction() * desires[dir])
	Drawing.draw_vectors_in_circle(self, 10, vectors, Color.white)
	pass


