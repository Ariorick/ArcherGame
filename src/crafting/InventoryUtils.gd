extends Node
class_name InventoryUtils


static func duplicate_item(item: Item) -> Item:
	return Item.new(item.id)
