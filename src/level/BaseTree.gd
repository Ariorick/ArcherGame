extends Area2D
class_name BaseTree

const level2_sprite = preload("res://assets/flat/red_leaves_with_shade copy.png")

onready var tween: Tween = $Tween

var level = 1

var growth_dict := Dictionary()
var orientation = Vector2(sign(rand_range(-1, 1)), 1) * 1.4 # last number can be used as size modifyer
var current_growth: float = 1.0
var modulation_growth: float = 0.0

func _ready():
	if level == 2:
		$Sprite.texture = level2_sprite

func _process(delta):
	modulation_growth = (TreeModulationNoise.get_modulation(global_position) + 1) / 6
	var growth = clamp(current_growth - modulation_growth, 0, 1)
	_apply_growth(growth)
	pass

# 0 to 1 float
func set_growth(growth: float, author, level: int = 1):
	if level < self.level:
		return 
	
	growth_dict[author] = growth
	growth = get_lowest_growth()
	_setup_tweens(growth)


func _setup_tweens(growth: float):
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

func _apply_growth(growth: float):
	$Sprite.scale = Vector2(growth, growth) * orientation


func get_lowest_growth() -> float:
	var min_value = 100000.0
	for value in growth_dict.values():
		min_value = min(min_value, value)
	return min_value
