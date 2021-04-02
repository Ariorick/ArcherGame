extends Area2D
class_name BaseTree

var growth_dict := Dictionary()
var orientation = Vector2(sign(rand_range(-1, 1)), 1)

func _ready():
	var frame_count = $AnimatedSprite.frames.get_frame_count("growing")
	$AnimatedSprite.frame = frame_count - 1

# 0 to 1 float
func set_growth(growth: float, author):
	growth_dict[author] = growth
	growth = get_lowest_growth()
	$Sprite.scale = Vector2(growth, growth) * orientation
	$Sprite.position = Vector2(0, -8) + Vector2(0, 16) * (1 - growth)
	
	
	var frame_count = $AnimatedSprite.frames.get_frame_count("growing")
	var frame = int(growth * frame_count)
	$AnimatedSprite.frame = frame
	



func get_lowest_growth() -> float:
	var min_value = 100000.0
	for value in growth_dict.values():
		min_value = min(min_value, value)
	return min_value
