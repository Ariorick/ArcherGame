extends CanvasLayer



onready var health_bar = $GUI/VBoxContainer/HBoxContainer/HealthDisplay
onready var arrow_label = $GUI/VBoxContainer/HBoxContainer2/ArrowCount

func _ready():
	UiHolder.ui = self
	health_bar.set_max_value(GameManager.MAX_HEALTH)


func _process(delta):
	health_bar.update_healthbar(GameManager.health)
	arrow_label.text = str(GameManager.arrow_count) + "/" + str(GameManager.MAX_ARROW_COUNT)




