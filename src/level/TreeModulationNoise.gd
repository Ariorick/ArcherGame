extends Node

var noise: OpenSimplexNoise

func _ready():
	prepare_noise()

func get_modulation(tree_pos: Vector2) -> float:
	var time = OS.get_ticks_msec()
	var speed = 100
	var amplitude = 1
	return amplitude * noise.get_noise_2d(tree_pos.x + time / speed, tree_pos.y + time / speed)

func prepare_noise():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.persistence = 0.7
	noise.octaves = 1.0
	noise.period = 30
