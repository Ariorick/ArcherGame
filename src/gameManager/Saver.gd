extends Node
# SAVER

const VERSION = 1
const SAVE_FILE = "user://savegame.save"

func _ready():
	load_game()

func apply_loaded_save(save: Dictionary, save_text: String):
	if not save.has("version") or VERSION != save["version"]:
		print ("Save file has different version")
		return
	
	Inventory.set_items(save["inventory"])
	GameManager.reset_player()
	
	print("Game loaded, save:")
	print(save_text)

func create_save() -> Dictionary:
	var save := Dictionary()
	save["save_time"] = TimeUtils.get_date_time_string()
	save["timestamp"] = OS.get_unix_time()
	save["version"] = VERSION
	save["inventory"] = Inventory.items
	return save

func load_game():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_FILE):
		print ("No save file")
		return
	save_file.open(SAVE_FILE, File.READ)
	
	var save_text = save_file.get_as_text()
	if save_text == null:
		print ("Corrupted save")
		return
	
	var save_json = parse_json(save_text)
	if typeof(save_json) != TYPE_DICTIONARY:
		print ("Corrupted save")
		return
	
	var save: Dictionary = save_json
	apply_loaded_save(save, save_text)
	
	save_file.close()

func save_game():
	var dir = Directory.new()
	if dir.file_exists(SAVE_FILE):
		dir.remove(SAVE_FILE)
	var save_file = File.new()
	save_file.open(SAVE_FILE, File.WRITE)
	
	var save = create_save()
	
	var pretty_json = JsonFormatter.beautify_json(to_json(save))
	save_file.store_line(pretty_json)
	save_file.close()
	print("Game saved")

func delete_save():
	var dir = Directory.new()
	dir.remove("user://savegame.save")
