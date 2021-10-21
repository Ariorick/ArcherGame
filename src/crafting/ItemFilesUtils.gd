extends Node
class_name ItemFilesUtils

const DIRECTORY_PATH := "res://src/crafting/items/"
const FILE_FORMAT := ".json"


static func id_from_path(path: String) -> String:
	var id_start = path.find_last("/") + 1
	return path.substr(id_start, path.find_last(".") - id_start)


static func get_all_items_ids() -> Array:
	var files = []
	var dir := Directory.new()
	dir.open(DIRECTORY_PATH)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(FILE_FORMAT):
			files.append(file.substr(0, file.find_last(".")))
	
	dir.list_dir_end()
	return files

static func item_path_by_id(item_id: String) -> String:
	return DIRECTORY_PATH + item_id + FILE_FORMAT
