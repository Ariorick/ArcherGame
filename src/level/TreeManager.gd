extends Node2D
class_name TreeManager

const BaseTree = preload("res://src/level/BaseTree.tscn")

var chunk_size := Vector2(4, 4) # cells
var cell_size_px := Vector2(18, 18) # distance between trees
var chunk_size_px := chunk_size * cell_size_px
var map_cells := Dictionary()
var lookaround := Vector2()

var trees: Dictionary # Vector2 (cell) to Tree
var pending_generate: Array = Array() # of Rect2s 
var pending_destroy: Array = Array() # of Rect2s 
var chunks_for_debug_draw: Array = Array() # of Rect2s 

onready var textureMap: TextureMap = $TextureMap
onready var content: Node2D = $"../Content/Objects"


func _ready():
	LightZoneManager.get_tree_level = funcref(self, "get_tree_level_by_position")
#	var camera_zoom = $CameraPosition/Camera2D.zoom
	var camera_zoom = 0.4
	var screen_size = get_viewport().size * camera_zoom

	lookaround = Vector2(
		Math.round_up(screen_size.x / chunk_size_px.x) / 2 + 1,
		Math.round_up(screen_size.y / chunk_size_px.y) / 2 + 1
		)


func _process(delta):
	var pos = GameManager.player_position
	generate_around(pos)
	execute_pending_operations()


func execute_pending_operations():
	var start_time = OS.get_ticks_msec()
	var max_time = 1
	if not pending_generate.empty():
		for rect in pending_generate:
			generate(rect.position, rect.end)
			pending_generate.erase(rect)
			if OS.get_ticks_msec() - start_time >= max_time:
				break


func apply(generate_array: Array, destroy_array: Array):	
	for rect in destroy_array:
		if pending_generate.has(rect):
			pending_generate.erase(rect)
		destroy(rect.position, rect.end)
	pending_generate.append_array(generate_array)
#	update() # for debugging


func generate(from: Vector2, to: Vector2):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			try_create_tree_at(x, y)

func destroy(from: Vector2, to: Vector2):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			var v = Vector2(x,y)
			if trees.has(v):
				trees[v].queue_free()
				trees.erase(v)

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

func generate_around(pos: Vector2):
	var chunk : = Vector2(
		Math.round_up(pos.x / chunk_size_px.x), 
		Math.round_up(pos.y / chunk_size_px.y)
		) - Vector2.ONE
	
	var x_start = chunk.x - lookaround.x
	var x_end = chunk.x + lookaround.x
	var y_start = chunk.y - lookaround.y
	var y_end = chunk.y + lookaround.y
	
	var generate_array: Array
	var destroy_array: Array
	chunks_for_debug_draw.clear()
	
	for x in range(x_start - 2, x_end + 2):
		for y in range(y_start - 2, y_end + 2):
			var v = Vector2(x, y)
			if x >= x_start and x <= x_end and y >= y_start and y <= y_end:
				chunks_for_debug_draw.append(rect_for_chunk(v))
				if not is_generated(v):
					generate_array.append(rect_for_chunk(v))
					map_cells[v] = true
			else:
				if is_generated(v):
					destroy_array.append(rect_for_chunk(v))
					map_cells[v] = false
	if not generate_array.empty() or not destroy_array.empty():
		apply(generate_array, destroy_array)

func is_generated(chunk: Vector2) -> bool: 
	return map_cells.has(chunk) && map_cells[chunk] == true

func rect_for_chunk(v: Vector2) -> Rect2:
	return Rect2(v * chunk_size, Vector2.ONE * chunk_size)

func can_place_tree1(x, y) -> bool:
	if not textureMap.is_woods1(get_position_for_cell(x, y)):
		return false
	return true

func can_place_tree2(x, y) -> bool:
	if not textureMap.is_woods2(get_position_for_cell(x, y)):
		return false
	return true

func get_position_for_cell_with_random(x, y) -> Vector2:
	var random_radius = cell_size_px.x / 2 - 1
	return get_position_for_cell(x, y) + Random.point_within_radius(random_radius)

func get_position_for_cell(x, y) -> Vector2:
	return cell_size_px * Vector2(x, y) + cell_size_px * Vector2(0.5, 1)

func _draw():
	for rect in chunks_for_debug_draw:
		var draw_rect = Rect2(rect.position * cell_size_px, rect.size * cell_size_px)
		draw_rect(draw_rect, Color.white, false, 2)
