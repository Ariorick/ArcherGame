extends Node

signal inventory_changed

var items: Dictionary # string with json path to count in inventory
var parsedItems: Array

func add(item: String, count = 1):
	if items.has(item):
		items[item] = items[item] + count
	else:
		items[item] = count
	reparseItems()

func reparseItems():
	parsedItems.clear()
	for path in items.keys():
		parsedItems.append(Item.new(path, items[path]))
	emit_signal("inventory_changed")

