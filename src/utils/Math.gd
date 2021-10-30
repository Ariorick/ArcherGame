extends Node
class_name Math

# rounds closer to positive infinity if .
static func round_up(value: float) -> int:
	if value > 0:
		if value - int(value) > 0:
			return int(value) + 1
	return int(value)
