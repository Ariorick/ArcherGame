extends Node

func add_by_name(name: String, count = 1):
	Inventory.add_by_name(name, count)
	Console.write_line('No such item: ' + name + '!')

func print_recipies():
	var result := Array()
	var result_string := ""
	for item in Inventory.item_types:
		if item.recipe != null and not item.recipe.empty():
			result_string += "[" + item.name + " " + str(item.recipe) + "] \n"
			result.append(item)
	Console.write_line(result_string)

