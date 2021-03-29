extends Node2D
class_name CircleFire

const TEXTURE_SCALE = 1.0

var circle: Circle setget set_circle

func _process(delta):
	$Light2D.rotation_degrees += 1


func circle_updated():
	print("circle_updated")
	$Light2D.texture_scale = TEXTURE_SCALE * circle.current_radius / circle.radius
	pass

func set_circle(value):
	circle = value
	circle.connect("circle_updated", self, "circle_updated")
