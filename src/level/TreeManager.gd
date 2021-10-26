extends Node2D

const BaseTree = preload("res://src/level/BaseTree.tscn")
var rng = RandomNumberGenerator.new()

var content: TileMap
var textureMap: TextureMap
var trees: Dictionary # Vector2 (cell) to Tree

func _ready():
#	LightZoneManager.get_tree_level = funcref(self, "get_tree_level")
	pass

func generate(from: Vector2, to: Vector2):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			try_create_tree_at(x, y)
#			try_create_rock_at(x, y)
			pass
	var children = content.get_children()
	pass

func try_create_tree_at(x, y):
	if not can_place_tree1(x, y) and not can_place_tree2(x, y):
		return
	
	var tree = BaseTree.instance()
	if can_place_tree2(x, y):
		tree.level = 2
	content.add_child(tree)
	tree.position = get_poisiton_for_cell_with_random(x, y)
	trees[Vector2(x,y)] = tree

func can_place_tree1(x, y) -> bool:
	if not textureMap.is_woods1(get_poisiton_for_cell(x, y)):
		return false
	return can_place_tree_frequency(x, y)

func can_place_tree2(x, y) -> bool:
	if not textureMap.is_woods2(get_poisiton_for_cell(x, y)):
		return false
	return can_place_tree_frequency(x, y)

func can_place_tree_frequency(x, y) -> bool:
	var xmod = int(abs(x + int(abs(y)) % 4)) % 2 # or 4
	var ymod2 = int(abs(y)) % 2 # or 4
	return xmod + ymod2 == 0

func get_poisiton_for_cell_with_random(x, y) -> Vector2:
	var rang = (content.cell_size.x / 2) - 1
	var rand_v = Vector2(rng.randf_range(-rang, rang), rng.randf_range(-rang, rang))
	return content.cell_size * Vector2(x, y) + content.cell_size * Vector2(0.5, 1) + rand_v

func get_poisiton_for_cell(x, y) -> Vector2:
	return content.cell_size * Vector2(x, y) + content.cell_size * Vector2(0.5, 1)
