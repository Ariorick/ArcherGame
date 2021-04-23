extends Area2D
class_name BaseTree

onready var tween: Tween = $Tween

var growth_dict := Dictionary()
var orientation = Vector2(sign(rand_range(-1, 1)), 1) * 1.7
var current_growth: float = 1.0
var modulation_growth: float = 0.0

func _process(delta):
	modulation_growth = (TreeModulationNoise.get_modulation(global_position) + 1) / 6
	_set_growth(current_growth)
	pass

# 0 to 1 float
func set_growth(growth: float, author):
	growth_dict[author] = growth
	growth = get_lowest_growth()
	
	if growth < current_growth:
		tween.stop(self, "_set_growth")
		tween.interpolate_method(self, "_set_growth", current_growth, growth, (current_growth - growth) / 2)
		tween.start()
	elif growth > current_growth:
		tween.stop(self, "_set_growth")
		tween.interpolate_method(self, "_set_growth", current_growth, growth, growth - current_growth)
		tween.start()

func _set_growth(growth: float):
	current_growth = growth
	growth = clamp(growth - modulation_growth, 0, 1)
	$Sprite.scale = Vector2(growth, growth) * orientation


func get_lowest_growth() -> float:
	var min_value = 100000.0
	for value in growth_dict.values():
		min_value = min(min_value, value)
	return min_value
