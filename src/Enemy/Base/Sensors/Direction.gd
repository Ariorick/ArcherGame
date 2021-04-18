class_name Direction 

var angle: float
var distance: float
var discovered_body: PhysicsBody2D

func _init(
		angle: float,
		distance: float,
		discovered_body: PhysicsBody2D
	):
	self.angle = angle
	self.distance = distance
	self.discovered_body = discovered_body

func get_vector() -> Vector2:
	return Vector2(distance, 0).rotated(angle)
