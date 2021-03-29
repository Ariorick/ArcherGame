extends Area2D
class_name BaseTree

func _ready():
	pass # Replace with function body.

# 0 to 1 float
func set_growth(growth: float):
	$Sprite.scale = Vector2(growth, growth)
