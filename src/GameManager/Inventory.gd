extends Node

signal inventory_changed

var items: Dictionary # string with json path to count in inventory
var parsed_items: Array
var item_types: Array #item

func add(item: String, count = 1):
	if items.has(item):
		items[item] = items[item] + count
	else:
		items[item] = count
	_reparseItems()

func add_by_name(name: String, count = 1):
	add(_item_path_by_name(name), count)


func _ready():
	var paths = _get_paths_for_items()
	item_types = _parse_item_types(paths)
	pass

func _reparseItems():
	parsed_items.clear()
	for path in items:
		parsed_items.append(Item.new(path, items[path]))
	emit_signal("inventory_changed")

func _parse_item_types(paths: Array) -> Array:
	var new_items := Array()
	for path in paths:
		new_items.append(Item.new(path, 0))
	return new_items

func _get_paths_for_items() -> Array:
	var directory_path := "res://src/crafting/items/"
	var files = []
	var dir := Directory.new()
	dir.open(directory_path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".json"):
			files.append(directory_path + file)
	
	dir.list_dir_end()
	return files

func _item_path_by_name(name: String) -> String:
	for item in Inventory.item_types: 
		if item.name.to_lower() == name.to_lower():
			return item.path
	print('No such item: ' + name + '!')
	return "NO PATH"
