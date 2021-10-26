extends Node2D

var prev_camera_pos = Vector2()

var chunk_size := Vector2(5, 5) # cells
var cell_size_px := Vector2(8, 8)
var chunk_size_px := chunk_size * cell_size_px
var map_cells := Dictionary()
var lookaround := Vector2()

func _ready():
	init_console()
	$World.chunk_size = chunk_size

#	var camera_zoom = $CameraPosition/Camera2D.zoom
	var camera_zoom = 0.5
	var screen_size = get_viewport().size * camera_zoom

	lookaround = Vector2(
		int(screen_size.x / chunk_size_px.x) / 2 + 2,
		int(screen_size.y / chunk_size_px.y) / 2 + 2
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
	
	for x in range(chunk.x - lookaround.x, chunk.x + lookaround.x):
		for y in range(chunk.y - lookaround.y, chunk.y + lookaround.y):
			generate_chunk(Vector2(x, y))

func generate_chunk(chunk: Vector2): 
	if map_cells.has(chunk) && map_cells[chunk] == true:
		return
	$World.generate(chunk)
	map_cells[chunk] = true

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
