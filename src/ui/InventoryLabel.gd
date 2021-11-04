extends Label
class_name InventoryLabel

func _ready():
	Inventory.connect("inventory_changed", self, "update_label")
	update_label()

func update_label():
	var instruments_string = "Instruments: \n"
	var inventory_string := "Inventory: \n"
	var parsed_items := Inventory.get_parsed_items()
	for item in parsed_items.keys():
			if Inventory.is_instrument(item.id):
				instruments_string += item.name + " " + str(parsed_items[item]) + "\n"
			else:
				inventory_string += item.name + " " + str(parsed_items[item]) + "\n"
	text = instruments_string + "\n" + inventory_string
