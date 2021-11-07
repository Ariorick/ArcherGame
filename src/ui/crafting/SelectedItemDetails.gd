extends MarginContainer
class_name SelectedItemDetails

const Ingredient = preload("res://src/ui/crafting/Ingredient.tscn")

var current_item: Item

onready var icon_control := $HBox/CenterContainer/ItemIcon
onready var igredients_control := $HBox/IngredientsList

func _ready():
	Inventory.connect("inventory_changed", self, "update_ui")
	update_ui()

func _on_item_selected(item: Item):
	current_item = item
	update_ui()

func update_ui():
	if current_item == null:
		visible = false
		return
	
	
	visible = true
	
	$HBox/ItemNameLabel.text = current_item.name
	icon_control.texture = load(current_item.icon)
	$HBox/Description.text = current_item.description
	
	var recipe = current_item.recipe
	NodeUtils.delete_children(igredients_control)
	for ingredient_id in recipe:
		var ingredient = Item.new(ingredient_id)
		var control = Ingredient.instance()
		control.icon = ingredient.icon
		control.amount_in_inventory = Inventory.amount_of(ingredient_id)
		control.amount_needed = recipe[ingredient_id]
		igredients_control.add_child(control)
	
	$HBox/CraftButton.disabled = not Inventory.can_craft(current_item.id)
#	show_craft_animation()


func _on_CraftButton_pressed():
	Inventory.craft(current_item.id)
	show_craft_animation()
	$HBox/CraftButton.disabled = true

func show_craft_animation():
	var step_1_time = 0.15
	var step_2_time = 0.5
	var new_scale = 2
	
	var icon_size: Vector2 = icon_control.rect_size
	var icon_position: Vector2 = icon_control.rect_position
	
	$Tween.interpolate_property(icon_control, ":rect_scale", Vector2.ONE, Vector2(new_scale, new_scale), \
		step_1_time, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.interpolate_property(icon_control, ":rect_position", \
		icon_position, icon_position  - icon_size * (new_scale / 2 - 0.5)  , \
		step_1_time, Tween.TRANS_QUAD, Tween.EASE_IN)
	
	$Tween.interpolate_property(icon_control, ":rect_scale", Vector2(new_scale, new_scale), Vector2.ONE, \
		step_2_time, Tween.TRANS_BOUNCE, Tween.EASE_OUT, step_1_time)
	$Tween.interpolate_property(icon_control, ":rect_position", \
		icon_position - icon_size * (new_scale / 2 - 0.5), icon_position, \
		step_2_time, Tween.TRANS_BOUNCE, Tween.EASE_OUT, step_1_time)
	$Tween.start()
	
	$ParticleTimer.wait_time = step_1_time + step_2_time - 0.3
	$ParticleTimer.start()
	$HBox/CenterContainer/Particles2D.position = $HBox/CenterContainer.rect_size / 2


func _on_ParticleTimer_timeout():
	$HBox/CenterContainer/Particles2D.emitting = true


func _on_Tween_tween_all_completed():
	update_ui()
	if not ArrayUtils.map_by_var(Inventory.get_available_recipies(), "id").has(current_item.id):
		visible = false
