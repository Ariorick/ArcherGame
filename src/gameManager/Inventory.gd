extends Node
# INVENNTORY

signal inventory_changed()
signal item_added(item_id, count)

var items: Dictionary # string ids to amount in inventory
var parsed_items: Array # of Item
var item_types: Dictionary # id to Item

# or subtract if amount is < 0
func add(item_id: String, amount = 1):
	if amount == 0:
		return 
	if items.has(item_id):
		items[item_id] = items[item_id] + amount
		if items[item_id] < 1:
			items.erase(item_id)
	else:
		items[item_id] = amount
	_reparseItems()
	
	if amount > 0:
		emit_signal("item_added", item_id, amount)

func can_craft(item_id, amount = 1) -> bool:
	return CraftingStation.can_craft(Item.new(item_id), items, amount)

func craft(item_id: String, amount = 1) -> bool:
	if CraftingStation.can_craft(Item.new(item_id), items, amount):
		items = CraftingStation.use(Item.new(item_id), items, amount)
		add(item_id, amount)
		_reparseItems()
		return true
	else:
		return false

func set_items(dict: Dictionary):
	items = dict
	_reparseItems()

func set_inventory_to_default():
	set_items({
		"magic_crystal":1
	})

func has(item_id) -> bool:
	return items.has(item_id)

func is_valid_id(item_id: String, count = 1) -> bool:
	return item_types.keys().has(item_id)

func _ready():
	var ids = ItemFilesUtils.get_all_items_ids()
	for id in ids:
		item_types[id] = Item.new(id, 0)
	set_inventory_to_default()

func _reparseItems():
	parsed_items.clear()
	for item_id in items:
		parsed_items.append(Item.new(item_id, items[item_id]))
	emit_signal("inventory_changed")


