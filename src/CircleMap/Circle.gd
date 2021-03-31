extends Node2D
class_name Circle

signal circle_updated

const INACTIVE_RADIUS = 0.8

var radius: float
export var current_radius: float

func _ready():
#	$AnimationPlayer.play("TestRadius")
	pass

func _process(delta):
	$TreeDetector.update_trees(current_radius)
	update()
	update_listeners()

func _draw():
#	draw_circle_custom(current_radius, Color.white)
	pass

func set_radius(radius: float):
	self.radius = radius
	$TreeDetector/CollisionShape2D.shape.radius = radius
	set_current_radius(radius * INACTIVE_RADIUS)

func set_current_radius(radius: float):
	current_radius = radius
	$TreeDetector.update_trees(radius)

func update_listeners():
	emit_signal("circle_updated")

func draw_circle_custom(radius, color):
	var maxerror = 0.25
	if radius <= 0.0:
		return
	var maxpoints = 1024 # I think this is renderer limit

	var numpoints = ceil(PI / acos(1.0 - maxerror / radius))
	numpoints = clamp(numpoints, 3, maxpoints)

	var points = PoolVector2Array([])

	for i in numpoints + 1:
		var phi = i * PI * 2.0 / numpoints
		var v = Vector2(sin(phi), cos(phi))
		points.push_back(v * radius)
	draw_polyline(points, color)
