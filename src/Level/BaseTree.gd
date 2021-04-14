extends Area2D
class_name BaseTree

onready var tween: Tween = $Tween

var growth_dict := Dictionary()
var orientation = Vector2(sign(rand_range(-1, 1)), 1)
var current_growth: float = 1.0
var modulation_growth: float = 0.0

func _ready():
	var frame_count = $AnimatedSprite.frames.get_frame_count("growing")
	$AnimatedSprite.frame = frame_count - 1

func _process(delta):
#	modulation_growth = (TreeModulationNoise.get_modulation(global_position) + 1) / 8
#	_set_growth(current_growth)
	pass

# 0 to 1 float
func set_growth(growth: float, author):
	if abs(growth - current_growth) < 0.005:
		return
	
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
	var position_offset = get_position_offset(growth)
	growth = clamp(growth - modulation_growth, 0, 1)
	
	$Sprite.scale = Vector2(growth, growth) * orientation
	$Sprite.position = Vector2(0, -8) + (Vector2(0, 16)) * (1 - growth) + position_offset
	
	var frame_count = $AnimatedSprite.frames.get_frame_count("growing")
	var frame = int(growth * frame_count)
	$AnimatedSprite.frame = frame
	$AnimatedSprite.position = Vector2(0, -8) + position_offset
	
	
	

func get_position_offset(growth: float) -> Vector2:
#	var min_value = 100000.0
#	var min_author
#	for author in growth_dict.keys():
#		if growth_dict[author] < min_value:
#			min_value = growth_dict[author]
#			min_author = author
#
#	var result_direction: Vector2 = Vector2.ZERO
#	if min_author == null:
#		return Vector2.ZERO
#	else:
#		var to_fire: Vector2 = min_author.global_position - global_position
#		var distance_clamped = min(1, to_fire.length_squared() * 10)
#		return to_fire.normalized() * 10 / distance_clamped * growth
	return Vector2.ZERO

func get_lowest_growth() -> float:
	var min_value = 100000.0
	for value in growth_dict.values():
		min_value = min(min_value, value)
	return min_value
