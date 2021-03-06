extends Node
class_name CraftingStation
# Creates crafted items based on recipes and using the materials contained in inventories
# Inventories are dictionaries: the keys represent items, and the amount available for each of them


static func can_craft(item: Item, inventory: Dictionary, amount: int = 1) -> bool:
	# Returns true if a certain item can be crafted based on the inventory's content
	var can_craft : = true
	if amount < 1 or item.recipe.empty() or not inventory.has_all(item.recipe.keys()):
		can_craft = false
	else:
		var adjusted_item : = adjust_item_recipe(item, amount)
		for ingredient in item.recipe:
			if adjusted_item.recipe[ingredient] > inventory[ingredient]:
				can_craft = false
				break
	return can_craft


static func adjust_item_recipe(item: Item, amount: int) -> Item:
	# Returns a new item with an adjusted recipe based on the amount of items to craft
	var adjusted_item : = InventoryUtils.duplicate_item(item)
	if amount > 1:
		for ingredient in adjusted_item.recipe:
			adjusted_item.recipe[ingredient] *= amount
	return adjusted_item


static func use(item: Item, inventory: Dictionary, amount: int = 1) -> Dictionary:
	# Creates and returns a new inventory with used up resources required to craft item
	var used_inventory = inventory.duplicate()
	var ajusted_recipe = adjust_item_recipe(item, amount).recipe
	if not inventory.has_all(ajusted_recipe.keys()):
		return used_inventory
	for ingredient in ajusted_recipe.keys():
		used_inventory[ingredient] -= ajusted_recipe[ingredient]
		if used_inventory[ingredient] == 0:
			used_inventory.erase(ingredient)
	return used_inventory

