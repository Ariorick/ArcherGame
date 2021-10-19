extends Node

var items: Dictionary # string with json path to count in inventory

func add(item: String, count = 1):
	if items.has(item):
		items[item] = items[item] + count
	else:
		items[item] = count


