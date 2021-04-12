extends Node2D

const BaseTree  = preload("res://src/Level/BaseTree.tscn")
var rng = RandomNumberGenerator.new()

var content: TileMap
var textureMap: TextureMap
var trees: Dictionary # Vector2 to Tree

func generate(from: Vector2, to: Vector2):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			create_tree_at(x, y)

func create_tree_at(x, y):
	if not can_place(x, y):
		return
	
	var tree = BaseTree.instance()
	content.add_child(tree)
	tree.position = get_poisiton_for_cell_with_random(x, y)
	trees[Vector2(x,y)] = tree

func can_place(x, y):
	if not textureMap.is_woods(get_poisiton_for_cell(x, y)):
		return false
	
	var xmod = int(abs(x + int(abs(y)) % 2)) % 2
	var ymod2 = int(abs(y)) % 2
	return xmod + ymod2 == 0

func get_poisiton_for_cell_with_random(x, y) -> Vector2:
	var rang = (content.cell_size.x / 2) - 1
	var rand_v = Vector2(rng.randf_range(-rang, rang), rng.randf_range(-rang, rang))
	return content.cell_size * Vector2(x, y) + content.cell_size * Vector2(0.5, 1) + rand_v

func get_poisiton_for_cell(x, y) -> Vector2:
	return content.cell_size * Vector2(x, y) + content.cell_size * Vector2(0.5, 1)
