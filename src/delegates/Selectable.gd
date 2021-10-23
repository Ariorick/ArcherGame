extends Area2D
class_name Selectable

# Use this to handle clicks on in-game objects and provide a tooltip
# You can extend it but still use signals
# Add a collision shape child

signal state_changed(is_hovered)
signal clicked()

var mouse_hovered := false
var tooltip: String

func _on_Selectable_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("attack") and mouse_hovered :
		emit_signal("clicked")

func _on_Selectable_mouse_entered():
	mouse_hovered = true
	emit_signal("state_changed", true)

func _on_Selectable_mouse_exited():
	mouse_hovered = false
	emit_signal("state_changed", false)
