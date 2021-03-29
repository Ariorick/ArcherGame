extends Node2D

const PineTree  = preload("res://src/Level/PineTree.tscn")

var content: TileMap
var circle_map: Array

func generate(from: Vector2, to: Vector2):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			make_trees_circles(x, y)

func make_trees_circles(x, y):
	var can_place = true
	for circle in circle_map:
		if is_in_radius(get_poisiton_for_cell(x, y), circle):
			can_place = false
	if can_place:
		create_tree_at(x, y)

func create_tree_at(x, y):
	var tree = PineTree.instance()
	content.add_child(tree)
	tree.position = get_poisiton_for_cell(x, y)

func is_in_radius(position: Vector2, circle: Circle) -> bool:
	return position.distance_to(circle.position) < circle.radius

func get_poisiton_for_cell(x, y):
	return content.cell_size * Vector2(x, y) + content.cell_size * Vector2(0.5, 1)

#func make_trees_map(x, y, value, value2):
#	if value > TREE_CAP:
#		var xmod = int(abs(x + int(abs(y)) % 9)) % 12
#		var ymod = int(abs(y)) % 6
#		var can_place = xmod + ymod == 0
#		if can_place:
#			create_tree_at(x, y)

