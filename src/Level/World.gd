extends Node2D

const YELLOW_CAP = 0.3
const GREEN_CAP = -0.6
const GRAVE_CAP = -0.3

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

func run_with_noise(from: Vector2, to: Vector2, generate_fun: FuncRef):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			var value = noise.get_noise_2d(x,y)
			generate_fun.call_func(x, y, value)
			$Grass.update_bitmask_region(from, to)

func update_regions(from: Vector2, to: Vector2):
	for child in get_children(): 
		child.update_bitmask_region(from, to)

func get_player():
	return $Graves/Player
