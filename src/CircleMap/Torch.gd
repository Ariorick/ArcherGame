extends Node2D
class_name Torch

signal finished
signal collected

const INITIAL_ANIM_TIME = 3
const FULL_LIFETIME = 15.0
const FLIKER_LIFETIME = 5.0
const TIME_BEFORE_FLICKER = FULL_LIFETIME - FLIKER_LIFETIME

const FULL_RADIUS = 50
const FLIKER_RADIUS = 40
const MIN_RADIUS = 28
const LIGHT_TEXTURE_SCALE = 0.003

var noise: OpenSimplexNoise 
var can_pickup_ref: FuncRef

var start_time: float = -1000
var active := false
var flickering := false
var on_the_ground := false

onready var tween: Tween = $Tween
onready var fire_particles : ParticlesBundle = $Visuals/FireParticles
onready var light : Light2D = $Visuals/Light2D
onready var sprite : Sprite = $Visuals/Sprite
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var tree_detector : CircleTreeDetector = $TreeDetector
onready var pickup_hint : ButtonHintActivator = $PickupHintActivator


func _ready():
	pickup_hint.conditions_met_ref = funcref(self, "can_be_piicked")
	pickup_hint.action = "use"
	pickup_hint.connect("action_just_pressed", self, "pick_up")
	prepare_noise()
	tree_detector.set_shape_radius(FULL_RADIUS * 3)
	reset()

func reset():
	$Visuals/ResetParticles.emitting = true
	active = true
	start_time = OS.get_ticks_msec()

# TODO: monstrous func, better split into multiples
func _process(delta):
	if not active:
		light.texture_scale = 0.2
		tree_detector.update_trees(0)
		fire_particles.emitting = false
		return 
	
	var elapced = (OS.get_ticks_msec() - start_time) / 1000
	
	var radius := 0.0
	if elapced < TIME_BEFORE_FLICKER:
		var elapced_percent = elapced / TIME_BEFORE_FLICKER
		radius = FLIKER_RADIUS + (FULL_RADIUS - FLIKER_RADIUS) * (1 - elapced_percent)
		light.energy = 1.0
	elif elapced < FULL_LIFETIME:
		var elapced_percent = (elapced - TIME_BEFORE_FLICKER) / FLIKER_LIFETIME
		radius = MIN_RADIUS + (FLIKER_RADIUS - MIN_RADIUS) * (1 - elapced_percent)
		light.energy = 1.0 - get_flickering() - elapced_percent / 4
	else:
		active = false
		emit_signal("finished")
	
	fire_particles.emitting = true
	light.texture_scale = LIGHT_TEXTURE_SCALE * radius
	tree_detector.update_trees(radius)

func on_thrown_away(direction: Vector2 = Vector2.ZERO):
	animation_player.play("ThrowTorchAway")
	if direction == Vector2.ZERO:
		var rng = RandomNumberGenerator.new()
		direction = Vector2(rng.randf(), rng.randf())
	tween.interpolate_property(self, "position", 
		position, position + 15 * direction.normalized(), 
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func landed_on_the_ground():
	on_the_ground = true

func pick_up():
	tween.interpolate_property(self, "global_position", 
		global_position, GameManager.player_position, 
		0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.connect("tween_completed", self, "tween_completed")
	tween.start()

func can_be_piicked() -> bool:
	return active and on_the_ground and can_pickup_ref.call_func()

# TODO: this is complete bullshit
func tween_completed(object, key):
	if key == ":global_position":
		collected()

func collected():
	on_the_ground = false
	emit_signal("collected", self)
	GameManager.player_collected_torch()

func get_flickering() -> float:
	var time = OS.get_ticks_msec()
	return (noise.get_noise_2d(time, 0) + 1) / 5


func prepare_noise():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.persistence = 0.7
	noise.octaves = 1.0
	noise.period = 30
