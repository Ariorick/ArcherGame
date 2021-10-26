extends Node
# SAVER

const SAVE_FILE = "user://savegame.save"

func _ready():
	load_game()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_FILE):
		return # Error! We don't have a save to load.
	save_game.open(SAVE_FILE, File.READ)
	
	Inventory.set_items(parse_json(save_game.get_line()))
	
	GameManager.reset_player()
	save_game.close()

func save_game():
	var dir = Directory.new()
	if not dir.file_exists(SAVE_FILE):
		dir.remove(SAVE_FILE)
	var save_game = File.new()
	save_game.open(SAVE_FILE, File.WRITE)
	
	save_game.store_line(to_json(Inventory.items))
	
	save_game.close()

func delete_save():
	var dir = Directory.new()
	dir.remove("user://savegame.save")
