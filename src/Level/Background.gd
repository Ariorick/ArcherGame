extends TileMap
class_name Background

const YELLOW_CAP = 0.3
const GRAVE_CAP = -0.3
const GREEN_CAP = -0.6

var content: TileMap
var textureMap: TextureMap
var rng = RandomNumberGenerator.new()

var noise
var secondary_noise

func _ready():
	prepare_noise()

func generate(from: Vector2, to: Vector2):
#	run_with_noise(from, to, funcref(self, "make_grass_map"))
#	run_with_noise(from, to, funcref(self, "make_graves_map"))
	pass

func make_grass_map(x, y, value):
	if not can_place(x, y):
		return
	
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
		if can_place and can_place(x, y):
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

func can_place(x, y) -> bool:
	return textureMap.has_background(get_poisiton_for_cell(x, y))

func get_poisiton_for_cell(x, y) -> Vector2:
	return content.cell_size * Vector2(x, y) + content.cell_size * Vector2(0.5, 1)

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
