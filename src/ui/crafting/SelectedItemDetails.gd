extends VBoxContainer
class_name SelectedItemDetails

const Ingredient = preload("res://src/ui/crafting/Ingredient.tscn")

var current_item

func _ready():
	visible = false

func _on_item_selected(item: Item):
	visible = true
	current_item = item
	$MarginContainer/ItemNameLabel.text = item.name
	$ItemIcon.texture = load(item.icon)
	$Description.text = item.description
	
	var recipe = item.recipe
	NodeUtils.delete_children($IngredientsList)
	for ingredient_id in recipe:
		var ingredient = Item.new(ingredient_id)
		var control = Ingredient.instance()
		control.icon = ingredient.icon
		control.count = recipe[ingredient_id]
		$IngredientsList.add_child(control)
	
	$CraftButton.disabled = not Inventory.can_craft(item.id)



func _on_CraftButton_button_up():
	Inventory.craft(current_item.id)
