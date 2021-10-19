extends Node

enum Item {
	STONE,
	WOOD
}

var items: Dictionary # item type to count


func add(item: int, count = 1):
	if items.has(item):
		items[item] = items[item] + count
	else:
		items[item] = count
