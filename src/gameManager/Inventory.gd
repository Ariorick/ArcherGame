extends Node
# INVENTORY

const INSTRUMENTS = ["axe", "pickaxe", "torch", "knife"]

signal inventory_changed()
signal item_added(item_id, count)

var items: Dictionary # string ids to amount in inventory
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
	_on_items_changed()
	
	if amount > 0:
		emit_signal("item_added", item_id, amount)


func can_craft(item_id: String, amount = 1) -> bool:
	return CraftingStation.can_craft(Item.new(item_id), items, amount)

func amount_of(item_id: String) -> int:
	if items.has(item_id):
		return items[item_id]
	else:
		return 0

func craft(item_id: String, amount = 1) -> bool:
	if CraftingStation.can_craft(Item.new(item_id), items, amount):
		items = CraftingStation.use(Item.new(item_id), items, amount)
		add(item_id, amount)
		_on_items_changed()
		return true
	else:
		return false


func set_items(dict: Dictionary):
	items = dict
	_on_items_changed()

func get_parsed_items() -> Dictionary: # Item to amount
	var parsed_items := Dictionary()
	for item_id in items:
		parsed_items[item_types[item_id]] = items[item_id]
	return parsed_items


func get_available_recipies() -> Array: # of Item that you're allowed to craft
	var avaiable_items := Array()
	var instruments_in_inventory := get_instruments_in_inventory()
	for item in item_types.values():
		if item.recipe.empty():
			continue
		if is_instrument(item.id):
			var instrument = parse_instrument(item.id)
			var current_level = 0
			if instruments_in_inventory.has(instrument[0]):
				current_level = instruments_in_inventory[instrument[0]]
			var recipe_level = instrument[1]
			if recipe_level != current_level + 1:
				continue
		
		avaiable_items.append(item)
	
	return avaiable_items

func is_instrument(item_id: String) -> bool:
	return StringUtils.begins_with_one_of(item_id, INSTRUMENTS)

func instrument_level(instrument_id: String) -> int:
	var instruments_in_inventory = get_instruments_in_inventory()
	if instruments_in_inventory.has(instrument_id):
		return instruments_in_inventory[instrument_id]
	return 0

func get_instruments_in_inventory() -> Dictionary: #instrument id to it's level
	var instruments = ArrayUtils.filter(items.keys(), funcref(self, "is_instrument"))
	var instruments_dict := Dictionary()
	
	for instrument in instruments:
		var parsed_instrument = parse_instrument(instrument)
		instruments_dict[parsed_instrument[0]] = parsed_instrument[1]
	
	return instruments_dict

func parse_instrument(instrument_id: String) -> Array: # 0 - instrument, 1 - level
	var instrument_name = instrument_id.substr(0, instrument_id.length() - 1)
	var last_symbol = StringUtils.last_symbol(instrument_id)
	return [instrument_name, int(last_symbol)]

func parse_items(item_ids: Array) -> Array:
	return ArrayUtils.map(item_ids, funcref(self, "parse_item"))


func parse_item(item_id: String) -> Item:
	return item_types[item_id]


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
		item_types[id] = Item.new(id)
	set_inventory_to_default()


func _on_items_changed():
	emit_signal("inventory_changed")

