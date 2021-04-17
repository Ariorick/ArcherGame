extends Node2D

var prev_camera_pos = Vector2()

var chunk_size := Vector2(10, 10) # cells
var cell_size_px := Vector2(8, 8)
var chunk_size_px := chunk_size * cell_size_px
var map_cells := Dictionary()
var lookaround := Vector2()

func _ready():
	$World.chunk_size = chunk_size

#	var camera_zoom = $CameraPosition/Camera2D.zoom
	var camera_zoom = 0.4
	var screen_size = get_viewport().size * camera_zoom

	lookaround = Vector2(
		int(screen_size.x / chunk_size_px.x) / 2 + 2,
		int(screen_size.y / chunk_size_px.y) / 2 + 2
		)

func _process(delta):
	var pos = $World.get_player().position
#	$CameraPosition.position = pos
	generate_around(pos)


func generate_around(pos: Vector2):
	var chunk : = Vector2(
		int(pos.x) / int(chunk_size_px.x), 
		int(pos.y) / int(chunk_size_px.y)
		)
	
	for x in range(chunk.x - lookaround.x, chunk.x + lookaround.x):
		for y in range(chunk.y - lookaround.y, chunk.y + lookaround.y):
			generate_chunk(Vector2(x, y))

func generate_chunk(chunk: Vector2): 
	if map_cells.has(chunk) && map_cells[chunk] == true:
		return
	$World.generate(chunk)
	map_cells[chunk] = true
	
