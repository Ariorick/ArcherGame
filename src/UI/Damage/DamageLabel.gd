extends Label
class_name DamageLabel

func set_start_position(position: Vector2):
	rect_position = position - rect_size / 2

func show_value(value, travel, duration, spread):
	text = value
	# For scaling, set the pivot offset to the center.
	rect_pivot_offset = rect_size / 2
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	# Animate the position.
	$Tween.interpolate_property(self, "rect_position", rect_position,
			rect_position + movement, duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	# Animate the fade-out.
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
