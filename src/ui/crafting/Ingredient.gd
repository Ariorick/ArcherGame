extends VBoxContainer

var icon: String
var amount_in_inventory: int
var amount_needed: int

func _ready():
	var is_enough = amount_in_inventory >= amount_needed
	$TextureRect.texture = load(icon)
	if is_enough:
		$TextureRect.modulate = Color(1, 1, 1, 1)
		$Label.modulate = Color(0, 1, 0, 0.7)
		$Label.text = str(amount_needed)
	else:
		$TextureRect.modulate = Color(1, 1, 1, 0.7)
		$Label.modulate = Color(1, 0, 0, 0.8)
		$Label.text = str(amount_in_inventory) + '/' + str(amount_needed)

