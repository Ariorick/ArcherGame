extends MarginContainer

onready var health_bar = $VBoxContainer/HBoxContainer/HealthDisplay
onready var arrow_label = $VBoxContainer/HBoxContainer2/ArrowCount

func _ready():
	health_bar.set_max_value(GameManager.MAX_HEALTH)


func _process(delta):
	health_bar.update_healthbar(GameManager.health)
	arrow_label.text = str(GameManager.arrow_count) + "/" + str(GameManager.MAX_ARROW_COUNT)




