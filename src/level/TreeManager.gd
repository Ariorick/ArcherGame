extends Node2D

const BaseTree = preload("res://src/level/BaseTree.tscn")
var rng = RandomNumberGenerator.new()

var content: TileMap
var textureMap: TextureMap
var trees: Dictionary # Vector2 (cell) to Tree

func _ready():
	LightZoneManager.get_tree_level = funcref(self, "get_tree_level_by_position")
	pass

func generate(from: Vector2, to: Vector2):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			try_create_tree_at(x, y)
#			try_create_rock_at(x, y)

func destroy(from: Vector2, to: Vector2):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			if trees.has(Vector2(x,y)):
				trees[Vector2(x,y)].queue_free()

func try_create_tree_at(x, y):
	var tree_level = get_tree_level_by_position(get_position_for_cell(x, y))
	if tree_level < 1:
		return
	
	var tree = BaseTree.instance()
	tree.level = tree_level
	content.add_child(tree)
	tree.position = get_position_for_cell_with_random(x, y)
	trees[Vector2(x,y)] = tree

func get_tree_level_by_position(v: Vector2) -> int:
	var tree_level = 0
	if textureMap.is_woods1(v):
		tree_level = 1
	elif textureMap.is_woods2(v):
		tree_level = 2
	return tree_level

func can_place_tree1(x, y) -> bool:
	if not textureMap.is_woods1(get_position_for_cell(x, y)):
		return false
	return can_place_tree_frequency(x, y)

func can_place_tree2(x, y) -> bool:
	if not textureMap.is_woods2(get_position_for_cell(x, y)):
		return false
	return can_place_tree_frequency(x, y)

func can_place_tree_frequency(x, y) -> bool:
	return true

func get_position_for_cell_with_random(x, y) -> Vector2:
	var rang = (content.cell_size.x / 2) - 1
	var rand_v = Vector2(rng.randf_range(-rang, rang), rng.randf_range(-rang, rang))
	return content.cell_size * Vector2(x, y) + content.cell_size * Vector2(0.5, 1) + rand_v

func get_position_for_cell(x, y) -> Vector2:
	return content.cell_size * Vector2(x, y) + content.cell_size * Vector2(0.5, 1)
