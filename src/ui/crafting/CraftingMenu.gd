extends MarginContainer
class_name CraftingMenu

signal on_opened()

func _ready():
	visible = false
	UiSignals.connect("open_crafting", self, "open")


func open():
	visible = true
	emit_signal("on_opened")


func _on_CloseButton_pressed():
	visible = false
