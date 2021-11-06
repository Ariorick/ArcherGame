class_name Desire

const TRIGGER_DISTANCE = 7

var angle: float
var has_obstacle: bool
var to_obstacle: float # in px

var target_desire: float  # in -1 to 1 
var evasion: float # in -1 to 1 

func _init(angle: float, has_obstacle: bool, to_obstacle: float):
	self.angle = angle
	self.has_obstacle = has_obstacle
	self.to_obstacle = to_obstacle


# from 0 to 1
func get_total_desire() -> float:
	if to_obstacle < TRIGGER_DISTANCE:
		return 0.0
	return target_desire

func get_direction() -> Vector2:
	return Vector2(1, 0).rotated(angle)
