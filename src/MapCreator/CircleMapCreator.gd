extends Node2D

const map_scale := 10.0
const DEF_SIZE = 12 * map_scale
const BIG_SIZE = 18 * map_scale

var DEF_DIAGONAL = get_diagonal(DEF_SIZE, DEF_SIZE)
var DEF_TO_BIG_CENTER = get_def_to_big_center(DEF_SIZE, BIG_SIZE)
var DEF_TO_BIG_DIAGONAL = get_diagonal(DEF_SIZE, BIG_SIZE)

var testMap = [
	Circle.new(Vector2(0, 0), DEF_SIZE),
	
	Circle.new(Vector2(-DEF_DIAGONAL, -DEF_DIAGONAL), DEF_SIZE),
	Circle.new(Vector2(DEF_DIAGONAL, -DEF_DIAGONAL), DEF_SIZE),
	
	Circle.new(Vector2(0, -DEF_DIAGONAL * 2 ), DEF_SIZE),
	
	Circle.new(Vector2(-DEF_DIAGONAL, -DEF_DIAGONAL * 3), DEF_SIZE),
	Circle.new(Vector2(DEF_DIAGONAL, - DEF_DIAGONAL * 3), DEF_SIZE),
	
	Circle.new(Vector2(0, -DEF_DIAGONAL * 3 - DEF_TO_BIG_CENTER), BIG_SIZE),
]

func _ready():
	set_ids_to_circles(testMap)
	$TestView.draw_map(testMap)
	pass

func get_map() -> Array:
	return testMap

func set_ids_to_circles(map: Array):
	for id in map.size():
		map[id].id = id

func get_diagonal(radius1, radius2) -> float:
	return sqrt(radius1 * radius1 + radius2 * radius2)

func get_def_to_big_center(radius1, radius2) -> float:
	return sqrt(pow(radius1 + radius2, 2) - pow(DEF_DIAGONAL, 2))

