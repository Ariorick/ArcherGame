extends Node

signal inventory_changed

var items: Dictionary # string ids to amount in inventory
var parsed_items: Array # of Item

var item_types: Array #item

func add(item_id: String, count = 1):
	if items.has(item_id):
		items[item_id] = items[item_id] + count
	else:
		items[item_id] = count
	_reparseItems()

func add_by_path(path: String, count = 1):
	add(ItemFilesUtils.id_from_path(path), count)

func _ready():
	var paths = ItemFilesUtils.get_paths_for_items()
	item_types = InventoryUtils.parse_item_types(paths)
	pass

func _reparseItems():
	parsed_items.clear()
	for item_id in items:
		parsed_items.append(Item.new(ItemFilesUtils.item_path_by_id(item_id), items[item_id]))
	emit_signal("inventory_changed")


