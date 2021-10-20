extends Node
class_name InventoryUtils


static func duplicate_item(item: Item) -> Item:
	return Item.new(item.path, item.count)

static func parse_item_types(paths: Array) -> Array:
	var new_items := Array()
	for path in paths:
		new_items.append(Item.new(path, 0))
	return new_items
