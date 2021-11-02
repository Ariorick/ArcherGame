extends Label

func _ready():
	Inventory.connect("inventory_changed", self, "inventory_changed")

func inventory_changed():
	var inventory_string := "Inventory: \n"
	for item in Inventory.parsed_items:
			inventory_string += item.name + " " + str(item.count) + "\n"
	text = inventory_string
