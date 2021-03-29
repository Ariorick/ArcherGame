extends Node2D

const PineTree  = preload("res://src/Level/PineTree.tscn")

var content: TileMap
var circle_map: Array
var trees: Dictionary # Vector2 to Tree

export var radius: float = 100.0

#func _ready(): 
#	$AnimationPlayer.play("TestTrees")
#
#func _process(delta):
#	update_trees()

func update_trees():
	for cell in trees.keys():
		var scale = get_scale_for_tree(cell, Circle.new(Vector2.ZERO, radius))
		trees[cell].scale = Vector2(scale, scale)

func generate(from: Vector2, to: Vector2):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			make_trees_everywhere(x, y)

func make_trees_everywhere(x, y):
	create_tree_at(x, y)

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
	trees[Vector2(x,y)] = tree

func is_in_radius(position: Vector2, circle: Circle) -> bool:
	return position.distance_to(circle.position) < circle.radius

func get_poisiton_for_cell(x, y):
	return content.cell_size * Vector2(x, y) + content.cell_size * Vector2(0.5, 1)

func get_scale_for_tree(cell: Vector2, circle: Circle) -> float:
	var pos = get_poisiton_for_cell(cell.x, cell.y)
	var distance = pos.distance_to(circle.position)
	
	var scale = distance / circle.radius
	
	var min_growth_distance := 1.0
	var max_growth_distance := 1.1
	var scale_between = (max_growth_distance * circle.radius - distance) / (max_growth_distance - min_growth_distance) / circle.radius
	
	if scale < min_growth_distance:
		return 0.0 
	elif scale > max_growth_distance:
		return 1.0
	else:
		return 1 - scale_between

#func make_trees_map(x, y, value, value2):
#	if value > TREE_CAP:
#		var xmod = int(abs(x + int(abs(y)) % 9)) % 12
#		var ymod = int(abs(y)) % 6
#		var can_place = xmod + ymod == 0
#		if can_place:
#			create_tree_at(x, y)

