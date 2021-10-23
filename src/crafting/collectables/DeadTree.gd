extends Collectable
class_name DeadTree

#override
func on_clicked():
	_add_item()
	queue_free()

#override
func condition() -> bool:
	return Inventory.has("axe")
