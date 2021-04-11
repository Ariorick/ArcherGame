extends Node2D
class_name Torch

const FULL_LIFETIME = 30.0
const FLIKER_LIFETIME = 15.0
const TIME_BEFORE_FLICKER = FULL_LIFETIME - FLIKER_LIFETIME

const FULL_RADIUS = 60
const FLIKER_RADIUS = 40
const MIN_RADIUS = 25
const LIGHT_TEXTURE_SCALE = 0.003

var noise: OpenSimplexNoise 
onready var tween: Tween = $Tween

var start_time: float = -1000
var active := false
var flickering := false

func _ready():
	prepare_noise()
	$TreeDetector.set_shape_radius(FULL_RADIUS + 10)
	active = true
	start_time = OS.get_ticks_msec()

func throw_away():
	pass

func _process(delta):
	if not active:
		$Light2D.texture_scale = 0
		$TreeDetector.update_trees(0)
		$Light2D.enabled = false
		$FireParticles.emitting = false
		return 
	
	var elapced = (OS.get_ticks_msec() - start_time) / 1000
	
	
	var radius := 0.0
	if elapced < TIME_BEFORE_FLICKER:
		var elapced_percent = elapced / TIME_BEFORE_FLICKER
		radius = FLIKER_RADIUS + (FULL_RADIUS - FLIKER_RADIUS) * (1 - elapced_percent)
		$Light2D.energy = 1.0
	elif elapced < FULL_LIFETIME:
		var elapced_percent = (elapced - TIME_BEFORE_FLICKER) / FLIKER_LIFETIME
		radius = MIN_RADIUS + (FLIKER_RADIUS - MIN_RADIUS) * (1 - elapced_percent)
		$Light2D.energy = 0.9 - get_flickering() * elapced_percent
	else:
		active = false
	
	$FireParticles.emitting = true
	$Light2D.enabled = true
	$Light2D.texture_scale = LIGHT_TEXTURE_SCALE * radius
	$TreeDetector.update_trees(radius)
	
	

func get_flickering() -> float:
	var time = OS.get_ticks_msec()
	return (noise.get_noise_2d(time, 0) + 1) / 3

func prepare_noise():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.persistence = 0.7
	noise.octaves = 1.0
	noise.period = 30
