extends TileMap

const YELLOW_CAP = 0.3
const GRAVE_CAP = -0.3
const GREEN_CAP = -0.6

var content: TileMap
var rng = RandomNumberGenerator.new()

var noise
var secondary_noise

func _ready():
	prepare_noise()

func generate(from: Vector2, to: Vector2):
	run_with_noise(from, to, funcref(self, "make_grass_map"))
	run_with_noise(from, to, funcref(self, "make_graves_map"))

func make_grass_map(x, y, value):
	if value > YELLOW_CAP:
		set_cell(x,y,2)
	else:
		set_cell(x,y,0)
	
	if value < GREEN_CAP:
		set_cell(x,y,1)

func make_graves_map(x, y, value):
	if value < GRAVE_CAP:
		var xmod = int(abs(x + int(abs(y)) % 4)) % 4
		var ymod2 = int(abs(y)) % 2
		var can_place = xmod + ymod2 == 0
		if can_place:
			var random_grave = rng.randi_range(2, 3)
			content.set_cell(x, y, random_grave)

func run_with_noise(from: Vector2, to: Vector2, generate_fun: FuncRef):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			var value = noise.get_noise_2d(x,y)
			generate_fun.call_func(x, y, value)
			update_bitmask_region(from, to)

func run_with_noise2(from: Vector2, to: Vector2, generate_fun: FuncRef):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			var value = noise.get_noise_2d(x,y)
			var value2 = secondary_noise.get_noise_2d(x,y)
			generate_fun.call_func(x, y, value, value2)
			update_bitmask_region(from, to)

func update_regions(from: Vector2, to: Vector2):
	for child in get_children(): 
		child.update_bitmask_region(from, to)

func prepare_noise():
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
