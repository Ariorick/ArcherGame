extends Position2D
class_name MouseCursor


func _process(delta):
	global_position = get_global_mouse_position()
	if get_viewport_rect().has_point(global_position):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
