extends Node2D

var prev_camera_pos = Vector2()

var chunk_size := Vector2(3, 3) # cells
var cell_size_px := Vector2(16, 16)
var chunk_size_px := chunk_size * cell_size_px
var map_cells := Dictionary()
var lookaround := Vector2()

func _ready():
	init_console()
	$World.chunk_size = chunk_size

#	var camera_zoom = $CameraPosition/Camera2D.zoom
	var camera_zoom = 0.3
	var screen_size = get_viewport().size * camera_zoom

	lookaround = Vector2(
		int(screen_size.x / chunk_size_px.x) / 2 + 1,
		int(screen_size.y / chunk_size_px.y) / 2 + 1
		)
	Saver.load_game()

func _process(delta):
	var pos = $World.get_player().position
#	$CameraPosition.position = pos
	generate_around(pos)


func generate_around(pos: Vector2):
	var chunk : = Vector2(
		int(pos.x) / int(chunk_size_px.x), 
		int(pos.y) / int(chunk_size_px.y)
		)
	
#	for x in range(chunk.x - lookaround.x, chunk.x + lookaround.x + 2):
#		for y in range(chunk.y - lookaround.y, chunk.y + lookaround.y + 2):
#			generate_chunk(Vector2(x, y))
	
	var x_start = chunk.x - lookaround.x
	var x_end = chunk.x + lookaround.x
	var y_start = chunk.y - lookaround.y - 1
	var y_end = chunk.y + lookaround.y + 1
	
	for x in range(x_start - 2, x_end + 2):
		for y in range(y_start - 2, y_end + 2):
			if x >= x_start and x <= x_end and y >= y_start and y <= y_end:
				generate_chunk(Vector2(x, y))
			else:
				destroy_chunk(Vector2(x, y))

func generate_chunk(chunk: Vector2): 
	if map_cells.has(chunk) && map_cells[chunk] == true:
		return
	$World.generate(chunk)
	map_cells[chunk] = true

func destroy_chunk(chunk: Vector2): 
	if not map_cells.has(chunk) or map_cells[chunk] == false:
		return
	$World.destroy(chunk)
	map_cells[chunk] = false

func init_console():
	Console.add_command('add', ConsoleExtensions, 'add_by_id')\
		.set_description('Adds %amount% of %resource_name% to inventory.')\
		.add_argument('resource_name', TYPE_STRING)\
		.add_argument('amount', TYPE_INT)\
		.register()
	
	Console.add_command('recipies', ConsoleExtensions, 'print_recipies')\
		.set_description('Returns recepies.')\
		.register()
	
	Console.add_command('types', ConsoleExtensions, 'print_item_types')\
		.set_description('Returns recepies.')\
		.register()
	
	Console.add_command('craft', ConsoleExtensions, 'craft')\
		.set_description('Tries to crafts item from inventory.')\
		.add_argument('resource_name', TYPE_STRING)\
		.add_argument('amount', TYPE_INT)\
		.register()
	
	Console.add_command('reset', self, 'reset')\
		.set_description('Removes save and resets player position')\
		.register()

func reset():
	Saver.delete_save()
	Inventory.set_items(Dictionary())
	GameManager.reset_player()
