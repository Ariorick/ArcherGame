extends Node

const DEF_ZOOM := 1.0
const DEF_OFFSET := Vector2.ZERO

var zoom : = DEF_ZOOM setget set_zoom, get_zoom
var position : = DEF_OFFSET setget set_position, get_position
var current_camera: Camera2D

var noise: OpenSimplexNoise
var tween = Tween.new()
var offset := Player.PLAYER_CENTER
var hit_offset := Vector2.ZERO
var darkness_amplitude := 0.0
var darkness_offset := Vector2.ZERO

func _ready():
	prepare_noise()
	add_child(tween)

func _process(delta):
#	darkness_offset = Random.point_within_radius(darkness_amplitude)
	if current_camera != null:
		current_camera.offset = _get_offset_sum()

func _get_offset_sum() -> Vector2:
	return offset + hit_offset + darkness_offset

func set_darkness_shiver_amplitude(amplitude: float):
	darkness_amplitude = amplitude

func enemy_hit_shake(direction: Vector2):
	hit_shake(direction, 1.2)

func player_hit_shake(direction: Vector2):
	hit_shake(direction, 3.0)

func pick_arrow_shake(arrow_velocity: Vector2):
	var amplitude = arrow_velocity.length() / 500
	hit_shake(-arrow_velocity, amplitude)

func hit_shake(direction: Vector2, amplitude: float):
	var hit_time = 0.05
	var return_time = 0.1
	var point = direction.normalized() * amplitude
	tween.stop_all()
	tween.interpolate_property(self, "hit_offset", Vector2.ZERO, point, hit_time, 
		Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(self, "hit_offset", point, Vector2.ZERO, return_time, 
		Tween.TRANS_BACK, Tween.EASE_OUT, hit_time)
	tween.start()

func set_zoom(value):
	zoom = value
	current_camera.zoom = Vector2(zoom, zoom)

func get_zoom():
	return zoom

func set_position(value):
	position = value
	current_camera.position = position

func get_position():
	return position

func set_current_camera(value):
	current_camera = value
	current_camera.zoom = Vector2(zoom, zoom)

func prepare_noise():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.persistence = 0.7
	noise.octaves = 1.0
	noise.period = 30
