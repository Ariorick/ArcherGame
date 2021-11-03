extends Node
# UiSignals

signal open_crafting
signal player_reset_torch

func open_crafting():
	emit_signal("open_crafting")

func player_reset_torch(time: int):
	emit_signal("player_reset_torch", time)
