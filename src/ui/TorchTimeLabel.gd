extends Label

var torch_end_time: int


func _ready():
	GameManager.connect("player_reset_torch", self, "player_reset_torch")


func _process(delta):
	if torch_end_time > OS.get_ticks_msec():
		set_text(str((torch_end_time - OS.get_ticks_msec()) / 1000))
	else:
		set_text("")


func player_reset_torch(time: int):
	torch_end_time = OS.get_ticks_msec() + time * 1000
