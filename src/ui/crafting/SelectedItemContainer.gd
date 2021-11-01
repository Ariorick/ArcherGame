extends VBoxContainer
class_name SelectedItemContainer

const Ingredient = preload("res://src/ui/crafting/Ingredient.tscn")


func _on_ItemList_on_item_selected(item):
	$MarginContainer/ItemNameLabel.set_text(item.name)
	
	var recipe = item.recipe
	NodeUtils.delete_children($IngredientsList)
	for item_name in recipe:
		var ingredient = Item.new(item_name)
		var control = Ingredient.instance()
		control.icon = ingredient.icon
		control.count = ingredient.count
		$IngredientsList.add_child(control)

