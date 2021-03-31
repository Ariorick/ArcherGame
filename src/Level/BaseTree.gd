extends Area2D
class_name BaseTree

var growth_dict := Dictionary()

func _ready():
	pass # Replace with function body.

# 0 to 1 float
func set_growth(growth: float, author):
	growth_dict[author] = growth
	growth = get_lowest_growth()
	$Sprite.scale = Vector2(growth, growth)

func get_lowest_growth() -> float:
	var min_value = 100000.0
	for value in growth_dict.values():
		min_value = min(min_value, value)
	return min_value
