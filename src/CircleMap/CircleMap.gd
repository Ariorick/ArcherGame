extends Node2D
class_name CircleMap

const CircleFire = preload("res://src/Level/CircleFire.tscn")

var content: TileMap setget set_content
var circle_array: Array = Array() # of Circle

func _ready():
#	$CircleMapCreator.create_map(self)
#	$CircleMapCreator.create_roads(self)
#	circle_array = get_circles_array()
	$TestView.draw_map(self)
	pass


func set_content(value: TileMap):
	content = value
	create_fires(circle_array)

func create_fires(circle_array: Array):
	for circle in circle_array:
		var fire = CircleFire.instance()
		content.add_child(fire)
		fire.global_position = circle.position
		fire.circle = circle

func get_circles_array() -> Array:
	var array = Array()
	for child in get_children():
		if child is Circle:
			array.append(child)
	return array

func is_in_radius(position: Vector2, circle: Circle) -> bool:
	return position.distance_to(circle.position) < circle.radius
