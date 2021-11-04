extends Area2D
class_name Interactable

# Use this to handle clicks on in-game objects and provide a tooltip
# You can extend it but still use signals
# Add a collision shape child

signal state_changed(is_hovered, close_to_player)
signal clicked(close_to_player)

var mouse_hovered := false
var close_to_player := false
var tooltip: String

func emit_state_changed():
	emit_signal("state_changed", mouse_hovered, close_to_player)

func _unhandled_input(event: InputEvent):
	if event.is_action("attack"):
		if Input.is_action_just_pressed("attack") and mouse_hovered:
			emit_signal("clicked", close_to_player)
			get_tree().set_input_as_handled()

func _on_Selectable_mouse_entered():
	mouse_hovered = true
	emit_state_changed()

func _on_Selectable_mouse_exited():
	mouse_hovered = false
	emit_state_changed()

func _on_PlayerDetector_body_entered(body):
	if body is Player:
		close_to_player = true
		emit_state_changed()

func _on_PlayerDetector_body_exited(body):
	if body is Player:
		close_to_player = false
		emit_state_changed()
