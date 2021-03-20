extends CanvasLayer


func _ready():
	$HealthDisplay.set_max_value(GameManager.MAX_HEALTH)
	GameManager.connect("player_health_changed", self, "player_health_changed")
	GameManager.connect("arrow_count_changed", self, "arrow_count_changed")
	pass

func player_health_changed():
	$HealthDisplay.update_healthbar(GameManager.health)

func arrow_count_changed():
	$ArrowCount.set_text(str(GameManager.arrow_count) + "/" + str(GameManager.MAX_ARROW_COUNT))
