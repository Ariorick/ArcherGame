extends Control

var map: Array

# Array of Circles
func draw_map(map: Array):
	self.map = map

func _draw():
	for circle in map:
		draw_circle(circle.position, circle.radius, Color.aliceblue)
