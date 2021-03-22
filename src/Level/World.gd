extends Node2D

const PineTree  = preload("res://src/Level/PineTree.tscn")

const YELLOW_CAP = 0.3
const TREE_CAP = 0.0
const GRAVE_CAP = -0.3
const GREEN_CAP = -0.6

var rng = RandomNumberGenerator.new()

var noise
var secondary_noise
var map_size = Vector2()

func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.persistence = 0.7
	noise.octaves = 1.0
	noise.period = 12
	randomize()
	secondary_noise = OpenSimplexNoise.new()
	secondary_noise.seed = randi()
	secondary_noise.persistence = 0.7
	secondary_noise.octaves = 1.0
	secondary_noise.period = 12
	
	
#	$Grass.cell_custom_transform = transform

func generate(chunk: Vector2):
	var from = chunk * map_size
	var to = (chunk + Vector2(1, 1)) * map_size
	run_with_noise(from, to, funcref(self, "make_grass_map"))
	run_with_noise(from, to, funcref(self, "make_graves_map"))
	run_with_noise2(from, to, funcref(self, "make_trees_map"))

func make_grass_map(x, y, value):
	if value > YELLOW_CAP:
		$Grass.set_cell(x,y,2)
	else:
		$Grass.set_cell(x,y,0)
	
	if value < GREEN_CAP:
		$Grass.set_cell(x,y,1)

func make_graves_map(x, y, value):
	if value < GRAVE_CAP:
		var xmod = int(abs(x + int(abs(y)) % 4)) % 4
		var ymod2 = int(abs(y)) % 2
		var can_place = xmod + ymod2 == 0
		if can_place:
			var random_grave = rng.randi_range(2, 3)
			$Graves.set_cell(x, y, random_grave)

func make_trees_map(x, y, value, value2):
	if value > TREE_CAP:
		var xmod = int(abs(x + int(abs(y)) % 8)) % 8
		var ymod = int(abs(y)) % 4
		var can_place = xmod + ymod == 0
		if can_place:
			create_tree_at(x, y)

func create_tree_at(x, y):
	var tree = PineTree.instance()
	$Graves.add_child(tree)
	tree.position = get_poisiton_for_cell(x, y)

func run_with_noise(from: Vector2, to: Vector2, generate_fun: FuncRef):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			var value = noise.get_noise_2d(x,y)
			generate_fun.call_func(x, y, value)
			$Grass.update_bitmask_region(from, to)

func run_with_noise2(from: Vector2, to: Vector2, generate_fun: FuncRef):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			var value = noise.get_noise_2d(x,y)
			var value2 = secondary_noise.get_noise_2d(x,y)
			generate_fun.call_func(x, y, value, value2)
			$Grass.update_bitmask_region(from, to)

func update_regions(from: Vector2, to: Vector2):
	for child in get_children(): 
		child.update_bitmask_region(from, to)

func get_poisiton_for_cell(x, y):
	return $Graves.cell_size * Vector2(x, y) + $Graves.cell_size * Vector2(0.5, 1)

func get_player():
	return $Graves/Player
