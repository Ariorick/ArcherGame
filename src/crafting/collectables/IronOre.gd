extends Collectable
class_name IronOre

#override
func on_clicked():
	_add_item()
	queue_free()

#override
func condition() -> bool:
	return Inventory.has("pickaxe")
