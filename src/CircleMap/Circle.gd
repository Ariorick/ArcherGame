extends Node2D
class_name Circle

signal circle_updated

const INACTIVE_RADIUS = 0.3
const MIN_ACTIVE_RADIUS = 0.6
const ACTIVATION_RADIUS = MIN_ACTIVE_RADIUS + 0.1
const NARROW_TIME = 60
const TWITCH_RADIUS = 0.1

export var current_radius: float

var program: SpawnerProgram
var top_roads: Array = Array()
var bottom_roads: Array = Array()
var radius: float setget set_radius

func _process(delta):
	$TreeDetector.update_trees(current_radius)
	update()
	update_listeners()

func _draw():
#	draw_circle_custom(current_radius, Color.white)
#	draw_circle_custom(radius, Color.red)
	pass

func activate():
	close_all_roads()
	var zoom_out_time = 1.5
	var zoom_in_time = 0.5
	var zoom = 1.1
	$ActivationTween.interpolate_property(self, "current_radius", 
		current_radius, radius * ACTIVATION_RADIUS, 3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$ActivationTween.interpolate_method(self, "set_camera_zoom", 
		1, zoom, zoom_out_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$ActivationTween.interpolate_method(self, "set_camera_zoom", 
		zoom, 1, zoom_in_time, Tween.TRANS_QUAD, Tween.EASE_OUT, zoom_out_time)
	$ActivationTween.start()

func _on_ActivationTween_tween_all_completed():
	narrow(current_radius)

func twitch():
	var twitch_time = 0.3
	var result_radius = min(current_radius + radius * TWITCH_RADIUS, radius)
	$ProcessTween.stop(self, "current_radius")
	$ProcessTween.interpolate_property(self, "current_radius", 
		current_radius, result_radius , twitch_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
	narrow(result_radius, twitch_time)

func narrow(from_radius: float, delay: float = 0.0):
	$ProcessTween.interpolate_property(self, "current_radius", 
		from_radius, MIN_ACTIVE_RADIUS * radius, 
		NARROW_TIME * (from_radius / radius - MIN_ACTIVE_RADIUS), Tween.TRANS_LINEAR, Tween.EASE_OUT, delay)
	$ProcessTween.start()

func finish():
	$ProcessTween.remove_all()
	$ProcessTween.interpolate_property(self, "current_radius", 
		current_radius, min(current_radius + 1.5, radius), 3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
	open_all_roads() 
	var zoom_out_time = 2.5
	var zoom_in_time = 1.0
	var zoom = 1.3
	$ProcessTween.interpolate_method(self, "set_camera_zoom", 
		1, zoom, zoom_out_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$ProcessTween.interpolate_method(self, "set_camera_offset", 
		Vector2.ZERO, Vector2(0, -radius / 2), zoom_out_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$ProcessTween.interpolate_method(self, "set_camera_zoom", 
		zoom, 1, zoom_in_time, Tween.TRANS_QUAD, Tween.EASE_OUT, zoom_out_time)
	$ProcessTween.interpolate_method(self, "set_camera_offset", 
		Vector2(0, -radius / 2), Vector2.ZERO, zoom_in_time, Tween.TRANS_QUAD, Tween.EASE_OUT, zoom_out_time)
	$ProcessTween.start()

func set_radius(value: float):
	radius = value
	$TreeDetector/CollisionShape2D.shape.radius = radius
	set_current_radius(radius * INACTIVE_RADIUS)

func set_current_radius(radius: float):
	current_radius = radius
	$TreeDetector.update_trees(radius)

func update_listeners():
	emit_signal("circle_updated")

func close_all_roads():
	for road in bottom_roads:
		road.close()
	for road in top_roads:
		road.close()

func open_all_roads():
	for road in top_roads:
		road.open()
	for road in top_roads:
		road.open()

func set_camera_zoom(value):
	CameraManager.zoom = value

func set_camera_offset(value):
	CameraManager.offset = value

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
