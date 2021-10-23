extends Node

signal inventory_changed

var items: Dictionary # string ids to amount in inventory
var parsed_items: Array # of Item
var item_types: Dictionary # id to Item

# or subtract if count is < 0
func add(item_id: String, count = 1):
	if count == 0:
		return 
	if items.has(item_id):
		items[item_id] = items[item_id] + count
		if items[item_id] < 1:
			items.erase(item_id)
	else:
		items[item_id] = count
	_reparseItems()

func can_craft(item_id, count) -> bool:
	return true

func craft(item_id: String, count = 1) -> bool:
	if CraftingStation.can_craft(Item.new(item_id), items, count):
		items = CraftingStation.use(Item.new(item_id), items, count)
		add(item_id, count)
		_reparseItems()
		return true
	else:
		return false

func has(item_id) -> bool:
	return items.has(item_id)

func is_valid_id(item_id: String, count = 1) -> bool:
	return item_types.keys().has(item_id)

func _ready():
	var ids = ItemFilesUtils.get_all_items_ids()
	for id in ids:
		item_types[id] = Item.new(id, 0)

func _reparseItems():
	parsed_items.clear()
	for item_id in items:
		parsed_items.append(Item.new(item_id, items[item_id]))
	emit_signal("inventory_changed")


