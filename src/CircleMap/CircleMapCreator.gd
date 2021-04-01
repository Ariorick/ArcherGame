extends Node2D

const Circle = preload("res://src/CircleMap/Circle.tscn")
const Road = preload("res://src/CircleMap/Road.tscn")

const map_scale := 7.0
const HORIZONTAL_INTERVAL = max(4 * map_scale, 80)
const VERTICAL_INTERVAL = max(3 * map_scale, 60)
const DEF_SIZE = 18 * map_scale
const BIG_SIZE = 30 * map_scale
const ROAD_WIDTH = 3 * map_scale


var only_skelly := {
	SpawnerProgram.SKELLY: 1,
}
var only_ghost := {
	SpawnerProgram.GHOST: 1,
}
var only_mage := {
	SpawnerProgram.MAGE: 1,
}
var skelly_ghost := {
	SpawnerProgram.SKELLY: 1,
	SpawnerProgram.GHOST: 1,
}
var skelly_mage := {
	SpawnerProgram.SKELLY: 1,
	SpawnerProgram.MAGE: 1,
}
var ghost_mage := {
	SpawnerProgram.GHOST: 1,
	SpawnerProgram.MAGE: 1,
}
var balanced_spawn := {
	SpawnerProgram.SKELLY: 1,
	SpawnerProgram.GHOST: 1,
	SpawnerProgram.MAGE: 1
}

var easy := {
	2: 1,
	4: 2,
}
var medium := {
	4: 2,
	8: 3
}
var hard := {
	8: 3,
	16: 4
}
var very_hard := {
	8: 4,
	16: 5
}

var test_map = [
	[ CircleRes.new(DEF_SIZE, SpawnerProgram.new(skelly_ghost, easy)) ],
	
	[ CircleRes.new(DEF_SIZE, SpawnerProgram.new(skelly_mage, medium)), 
		CircleRes.new(DEF_SIZE, SpawnerProgram.new(skelly_mage, medium)) ],
		
	[ CircleRes.new(DEF_SIZE, SpawnerProgram.new(balanced_spawn, medium)) ],
	
	[ CircleRes.new(DEF_SIZE, SpawnerProgram.new(balanced_spawn, hard)), 
		CircleRes.new(DEF_SIZE, SpawnerProgram.new(balanced_spawn, hard))],
		
	[ CircleRes.new(BIG_SIZE, SpawnerProgram.new(balanced_spawn, very_hard))]
]

# structure is Array of Arrays of CirclesRes
func create_map(parent: Node2D):
	var structure = test_map
	var circle_structure = [ Array() ]
	
	var first_circle: CircleRes = structure[0][0]
	circle_structure[0].append(
		create_circle(first_circle, Vector2.ZERO, parent)
	)
	
	var previous_level_top_end: = - first_circle.radius
	for level_id in range(1, structure.size()):
		circle_structure.append(Array())
		var level = structure[level_id]
		
		var level_top_end = 1000
		for id_in_level in level.size():
			var circle_res = level[id_in_level]
			var position = get_circle_position(circle_res.radius, previous_level_top_end, id_in_level, level.size())
			level_top_end = min(level_top_end, position.y - circle_res.radius - VERTICAL_INTERVAL)
			circle_structure[level_id].append(
				create_circle(circle_res, position, parent)
			)
			
		previous_level_top_end = level_top_end
	
	create_roads(circle_structure, parent)


func create_circle(circle_res: CircleRes, position: Vector2, parent: Node2D) -> Circle:
	var circle = Circle.instance()
	circle.program = circle_res.program
	circle.set_radius(circle_res.radius)
	parent.add_child(circle)
	circle.position = position
	return circle


# structure is Array of Arrays of actual Circles
func create_roads(structure: Array, parent: Node2D):
	
	var first_circle: Circle = structure[0][0]
	create_first_road(first_circle, parent)
	
	for level_id in range(0, structure.size() - 1):
		create_roads_between_levels(structure[level_id], structure[level_id + 1], parent)


func create_roads_between_levels(level1: Array, level2: Array, parent: Node2D):
	for level1_id in level1.size():
		for level2_id in level2.size():
			create_road_between(level1[level1_id], level2[level2_id], parent)

func create_road_between(bottom_circle: Circle, top_circle: Circle, parent: Node2D):
	var road = Road.instance()
	var road_vector = top_circle.position - bottom_circle.position
	road.length = road_vector.length() / 2
	road.width = ROAD_WIDTH
	
	parent.add_child(road)
	bottom_circle.top_roads.append(road)
	top_circle.bottom_roads.append(road)
	road.position = bottom_circle.position + 0.5 * road_vector
	road.rotation = road_vector.angle() + PI/2

func create_first_road(circle: Circle, parent):
	var road = Road.instance()
	road.length = circle.radius * 2
	road.width = ROAD_WIDTH
	road.current_width = ROAD_WIDTH
	
	parent.add_child(road)
	circle.bottom_roads.append(road)
	road.position = Vector2(0, circle.radius * 2)

func get_circle_position(
		radius: float, 
		previous_level_top_end: float, 
		id_in_level: int, 
		level_size: int
	) -> Vector2:
	var interval = radius * 2 + HORIZONTAL_INTERVAL
	var x_offset = - (level_size - 1) * interval / 2
	var x = x_offset + interval * id_in_level
	
	var y = previous_level_top_end - VERTICAL_INTERVAL - radius
	return Vector2(x, y)
