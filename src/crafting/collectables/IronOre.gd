extends Collectable
class_name IronOre


#override
func condition() -> bool:
	return Inventory.has("pickaxe")
