class_name PlayerInput

static func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength('right') - Input.get_action_strength('left'),
		Input.get_action_strength('down') - Input.get_action_strength('up')
	).normalized()

static func get_mouse_direction(node: Node) -> Vector2:
	var screen_size := Vector2(
		ProjectSettings.get_setting("display/window/size/width"), 
		ProjectSettings.get_setting("display/window/size/height")
	)
	return (node.get_viewport().get_mouse_position() - screen_size / 2).normalized()
