extends Node2D

var chunk_size = Vector2()

func _ready():
	$TreeManager.content = $Content/Objects
#	$Background.content = $Content
	$TreeManager.textureMap = $TextureMap
#	$Background.textureMap = $TextureMap

func generate(chunk: Vector2):
	var from = chunk * chunk_size
	var to = (chunk + Vector2(1, 1)) * chunk_size
#	$Background.generate(from, to)
	$TreeManager.generate(from, to)

func get_player():
	return $Content/Objects/Player
