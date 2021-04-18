class_name Direction 

var angle: float
var distance: float
var collider: Node2D

func _init(
		angle: float,
		distance: float,
		collider: Node2D
	):
	self.angle = angle
	self.distance = distance
	self.collider = collider

func get_vector() -> Vector2:
	return Vector2(distance, 0).rotated(angle)

func get_direction() -> Vector2:
	return get_vector().normalized()

func has_collider() -> bool:
	return collider != null
