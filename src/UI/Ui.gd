extends CanvasLayer

var torch_end_time: int

func _ready():
	UiHolder.ui = self
	$HealthDisplay.set_max_value(GameManager.MAX_HEALTH)
	GameManager.connect("player_health_changed", self, "player_health_changed")
	GameManager.connect("arrow_count_changed", self, "arrow_count_changed")
	GameManager.connect("damage_changed", self, "damage_changed")
	GameManager.connect("kill_count_changed", self, "kill_count_changed")
	GameManager.connect("player_reset_torch", self, "player_reset_torch")
	Inventory.connect("inventory_changed", self, "inventory_changed")
	update()

func _process(delta):
	if torch_end_time > OS.get_ticks_msec():
		$TorchTime.set_text(str((torch_end_time - OS.get_ticks_msec() + 1000) / 1000))
	else:
		$TorchTime.set_text("")
	

func update():
	kill_count_changed()
	damage_changed()
	player_health_changed()
	arrow_count_changed()


func inventory_changed():
	var inventory_string := "Inventory: \n"
	for item in Inventory.parsed_items:
			inventory_string += item.name + " " + str(item.count) + "\n"
	$Inventory.set_text(inventory_string)

func kill_count_changed():
	$KillCount.set_text("kills - " + str(GameManager.kill_count))

func damage_changed():
	$DamageDealt.set_text("damage dealt - " + str(GameManager.damage_dealt))

func player_health_changed():
	$HealthDisplay.update_healthbar(GameManager.health)

func arrow_count_changed():
	$ArrowCount.set_text(str(GameManager.arrow_count) + "/" + str(GameManager.MAX_ARROW_COUNT))

func player_reset_torch(time: int):
	torch_end_time = OS.get_ticks_msec() + time * 1000
