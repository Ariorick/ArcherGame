extends Node

const DEF_ZOOM := 1.0
const DEF_OFFSET := Vector2.ZERO

var zoom : = DEF_ZOOM setget set_zoom, get_zoom
var offset : = DEF_OFFSET setget set_offset, get_offset
var current_camera: Camera2D

func set_zoom(value):
	zoom = value
	current_camera.zoom = Vector2(zoom, zoom)

func get_zoom():
	return zoom

func set_offset(value):
	offset = value
	current_camera.position = offset

func get_offset():
	return offset

func set_current_camera(value):
	current_camera = value
	current_camera.zoom = Vector2(zoom, zoom)
