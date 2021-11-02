extends MarginContainer
class_name CraftingMenu

func _ready():
	visible = false
	UiSignals.connect("open_crafting", self, "open")

func open():
	visible = true

func _on_CloseButton_button_up():
	visible = false



func _on_PanelContainer_mouse_entered():
	pass # Replace with function body.
