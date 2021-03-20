extends CanvasLayer


func _ready():
	$HealthDisplay.set_max_value(GameManager.MAX_HEALTH)
	GameManager.connect("player_health_changed", self, "player_health_changed")
	GameManager.connect("arrow_count_changed", self, "arrow_count_changed")
	GameManager.connect("damage_changed", self, "damage_changed")
	GameManager.connect("kill_count_changed", self, "kill_count_changed")
	update()

func update():
	kill_count_changed()
	damage_changed()
	player_health_changed()
	arrow_count_changed()

func kill_count_changed():
	$KillCount.set_text("kills - " + str(GameManager.kill_count) + " " + get_exclamations())

func damage_changed():
	$DamageDealt.set_text("damage dealt - " + str(GameManager.damage_dealt) + " " + get_exclamations())

func player_health_changed():
	$HealthDisplay.update_healthbar(GameManager.health)

func arrow_count_changed():
	$ArrowCount.set_text(str(GameManager.arrow_count) + "/" + str(GameManager.MAX_ARROW_COUNT))

func get_exclamations() -> String:
	return repeat_string(log_with_base(GameManager.kill_count, 2), "!")

func repeat_string(count: int, string: String):
	var result := ""
	for i in count:
		result += string
	return result

func log_with_base(value, base):
	return log(value) / log(base)
