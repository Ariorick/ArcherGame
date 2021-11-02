extends Control
class_name CollectedItem

const CollectedItemAnimation = preload("res://src/ui/crafting/collected/CollectedItemAnimation.tscn")

const SPREAD = 12 #px

var item_id: String
var amount

var i: int = 1

func _ready():
	Inventory.connect("item_added", self, "show_new_items")

func show_new_items(item_id: String, amount: int):
	self.item_id = item_id
	self.amount = amount
	i = 1
	$Timer.start()

func _on_Timer_timeout():
	if i == amount:
		$Timer.stop()
	i += 1
	var item_animation = CollectedItemAnimation.instance()
	var item = Item.new(item_id)
	item_animation.texture = load(item.icon)
	add_child(item_animation, 0)
	item_animation.rect_position = Vector2(-(SPREAD * amount)/2 + SPREAD * i, 0)
