extends Node2D
class_name CircleFire

const TEXTURE_SCALE = 0.003

var circle: Circle setget set_circle


func circle_updated():
	print("circle_updated")
	$Light2D.texture_scale = TEXTURE_SCALE * circle.radius * circle.current_radius / circle.radius
	pass

func set_circle(value):
	circle = value
	circle.connect("circle_updated", self, "circle_updated")
