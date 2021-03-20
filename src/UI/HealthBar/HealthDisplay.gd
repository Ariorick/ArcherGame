extends Control

var bar_red = preload("res://src/UI/HealthBar/barHorizontal_red.png")
var bar_green = preload("res://src/UI/HealthBar/barHorizontal_green.png")
var bar_yellow = preload("res://src/UI/HealthBar/barHorizontal_yellow.png")

onready var healthbar = $HealthBar

func _ready():
	if get_parent() and get_parent().get("max_health"):
		healthbar.max_value = get_parent().max_health
	
#func _process(delta):
#	global_rotation = 0
	
func update_healthbar(value):
	healthbar.texture_progress = bar_green
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	if value < healthbar.max_value:
		show()
	healthbar.value = value

func set_max_value(value: int):
	healthbar.max_value = value
