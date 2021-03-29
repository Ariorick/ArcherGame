extends Node2D
class_name CircleMap

var circle_array: Array = Array() # of Circle

func _ready():
	$CircleMapCreator.create_circles(self)
	circle_array = get_circles_array()
	$TestView.draw_map(circle_array)

func get_circles_array() -> Array:
	var array = Array()
	for child in get_children():
		if child is Circle:
			array.append(child)
	return array

func is_in_radius(position: Vector2, circle: Circle) -> bool:
	return position.distance_to(circle.position) < circle.radius
