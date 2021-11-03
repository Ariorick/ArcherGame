extends MarginContainer
class_name SelectedItemDetails

const Ingredient = preload("res://src/ui/crafting/Ingredient.tscn")

var current_item

func _ready():
	visible = false

func _on_item_selected(item: Item):
	visible = true
	current_item = item
	$HBox/ItemNameLabel.text = item.name
	$HBox/ItemIcon.texture = load(item.icon)
	$HBox/Description.text = item.description
	
	var recipe = item.recipe
	NodeUtils.delete_children($HBox/IngredientsList)
	for ingredient_id in recipe:
		var ingredient = Item.new(ingredient_id)
		var control = Ingredient.instance()
		control.icon = ingredient.icon
		control.count = recipe[ingredient_id]
		$HBox/IngredientsList.add_child(control)
	
	$HBox/CraftButton.disabled = not Inventory.can_craft(item.id)


func _on_CraftButton_pressed():
	Inventory.craft(current_item.id)
