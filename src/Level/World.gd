extends Node2D

var map_size = Vector2()

func _ready():
	$TreeManager.content = $Content
	$Background.content = $Content

func generate(chunk: Vector2):
	var from = chunk * map_size
	var to = (chunk + Vector2(1, 1)) * map_size
	$Background.generate(from, to)
	$TreeManager.generate(from, to)
	$TreeManager.circle_map = $CircleMapCreator.get_map()

func get_player():
	return $Content/Player
