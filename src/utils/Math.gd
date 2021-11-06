extends Node
class_name Math

# rounds closer to positive infinity if .
static func round_up(value: float) -> int:
	if value > 0:
		if value - int(value) > 0:
			return int(value) + 1
	return int(value)

static func round_up_v(v: Vector2) -> Vector2:
	return Vector2(round_up(v.x), round_up(v.y))

static func round_v(v: Vector2) -> Vector2:
	return Vector2(round(v.x), round(v.y))
