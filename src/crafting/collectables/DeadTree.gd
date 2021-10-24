extends Collectable
class_name DeadTree


#override
func condition() -> bool:
	return Inventory.has("axe")
