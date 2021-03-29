extends Node2D

const Circle = preload("res://src/MapCreator/Circle.tscn")
const Road = preload("res://src/MapCreator/Road.tscn")

const map_scale := 10.0
const DEF_SIZE = 12 * map_scale
const BIG_SIZE = 18 * map_scale

var DEF_DIAGONAL = get_diagonal(DEF_SIZE, DEF_SIZE)
var DEF_TO_BIG_CENTER = get_def_to_big_center(DEF_SIZE, BIG_SIZE)
var DEF_TO_BIG_DIAGONAL = get_diagonal(DEF_SIZE, BIG_SIZE)

var test_map = [
	CircleRes.new(Vector2(0, 0), DEF_SIZE),
	
#	CircleRes.new(Vector2(-DEF_DIAGONAL, -DEF_DIAGONAL), DEF_SIZE),
#	CircleRes.new(Vector2(DEF_DIAGONAL, -DEF_DIAGONAL), DEF_SIZE),
#
#	CircleRes.new(Vector2(0, -DEF_DIAGONAL * 2 ), DEF_SIZE),
#
#	CircleRes.new(Vector2(-DEF_DIAGONAL, -DEF_DIAGONAL * 3), DEF_SIZE),
#	CircleRes.new(Vector2(DEF_DIAGONAL, - DEF_DIAGONAL * 3), DEF_SIZE),
#
#	CircleRes.new(Vector2(0, -DEF_DIAGONAL * 3 - DEF_TO_BIG_CENTER), BIG_SIZE),
]

func create_circles(parent: Node2D):
	for circle_res in test_map:
		var circle = Circle.instance()
		parent.add_child(circle)
		circle.position = circle_res.position
		circle.set_radius(circle_res.radius)

func create_roads(parent):
	create_first_road(parent)

func create_first_road(parent):
	var road = Road.instance()
	parent.add_child(road)
	road.position = Vector2(0, 100)
	road.set_length(100)
	road.set_width(30)

func get_diagonal(radius1, radius2) -> float:
	return sqrt(radius1 * radius1 + radius2 * radius2)

func get_def_to_big_center(radius1, radius2) -> float:
	return sqrt(pow(radius1 + radius2, 2) - pow(DEF_DIAGONAL, 2))
