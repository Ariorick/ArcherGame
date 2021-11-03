extends ItemList
class_name RecipiesList

signal on_item_selected(item)

var recipies := Array()

func _ready():
	Inventory.connect("inventory_changed", self, "update_list")
	update_list()


func update_list():
	clear()
	recipies.clear()
	for item in Inventory.item_types.values():
		if not item.recipe.empty():
			recipies.append(item)
			add_item(item.name, load(item.icon))


func _on_ItemList_item_selected(index):
	emit_signal("on_item_selected", recipies[index])


func _on_CraftingMenu_on_opened():
	if not is_anything_selected():
		select(0)
		emit_signal("on_item_selected", recipies[0])
