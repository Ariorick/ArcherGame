extends Node

const DEF_ZOOM := 1.0

var zoom : = DEF_ZOOM setget set_zoom, get_zoom
var current_camera: Camera2D

func set_zoom(value):
	zoom = value
	current_camera.zoom = Vector2(zoom, zoom)

func get_zoom():
	return zoom

func set_current_camera(value):
	current_camera = value
	current_camera.zoom = Vector2(zoom, zoom)
