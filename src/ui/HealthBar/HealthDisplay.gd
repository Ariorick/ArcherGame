extends TextureProgress
class_name HealthBar

var bar_red = preload("res://src/ui/HealthBar/barHorizontal_red.png")
var bar_green = preload("res://src/ui/HealthBar/barHorizontal_green.png")
var bar_yellow = preload("res://src/ui/HealthBar/barHorizontal_yellow.png")

func _ready():
	if get_parent() and get_parent().get("max_health"):
		max_value = get_parent().max_health


func update_healthbar(value):
	texture_progress = bar_green
	if value < max_value * 0.7:
		texture_progress = bar_yellow
	if value < max_value * 0.35:
		texture_progress = bar_red
	if value < max_value:
		show()


func set_max_value(value: int):
	max_value = value
