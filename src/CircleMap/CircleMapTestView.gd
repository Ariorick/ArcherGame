extends Node2D

var map: Array
var map_scale: float

# Array of Circles
func draw_map(map: Array):
	self.map = map
	var max_value = 1000
	for circle in map:
		max_value = min(circle.position.y, max_value)
	if max_value == 0:
		max_value = 1000
	map_scale = -50.0 / max_value 
	print(map_scale)

func _draw():
	for circle in map:
		draw_circle(circle.position * map_scale, circle.radius * map_scale, Color.aliceblue)
