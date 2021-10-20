extends Node

func add_by_id(id: String, count = 1):
	# TODO: add check if id is valid
	Inventory.add(id.to_lower(), count)
#	Console.write_line('No such item: ' + id + '!')

func print_recipies():
	var result := Array()
	var result_string := ""
	for item in Inventory.item_types:
		if item.recipe != null and not item.recipe.empty():
			result_string += "[" + item.id + " " + str(item.recipe) + "] \n"
			result.append(item)
	Console.write_line(result_string)

func print_item_types():
	var result := Array()
	for item in Inventory.item_types:
		result.append(item.id)
	Console.write_line(str(result))

func craft():
	pass
