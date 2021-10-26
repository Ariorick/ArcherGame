extends Node

var noise: OpenSimplexNoise

func _ready():
	prepare_noise()

func get_modulation(tree_pos: Vector2) -> float:
	var time = OS.get_ticks_msec()
	return noise.get_noise_2d(tree_pos.x + time / 100, tree_pos.y + time/ 100)

func prepare_noise():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.persistence = 0.7
	noise.octaves = 1.0
	noise.period = 30
