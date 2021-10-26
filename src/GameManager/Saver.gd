extends Node
# SAVER

func _ready():
	load_game()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	
	Inventory.set_items(parse_json(save_game.get_line()))
	
	GameManager.reset_player_position()
	save_game.close()

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	save_game.store_line(to_json(Inventory.items))
	
	save_game.close()
