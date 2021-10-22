extends Node2D
class_name Torch

signal finished
signal collected

const INITIAL_ANIM_TIME = 3
const FULL_LIFETIME = 30.0
const FLIKER_LIFETIME = 5.0
const TIME_BEFORE_FLICKER = FULL_LIFETIME - FLIKER_LIFETIME

const FULL_RADIUS = 80
const FLIKER_RADIUS = 60
const MIN_RADIUS = 28
const LIGHT_TEXTURE_SCALE = 0.003

var noise: OpenSimplexNoise 
var can_pickup_ref: FuncRef

var current_radius := 0.0
var start_time: float = -1000
var active := false
var flickering := false
var on_the_ground := false

onready var tween: Tween = $Tween
onready var fire_effect: FireEffect = $Visuals/FireEffect
onready var light : Light2D = $Visuals/Light2D
onready var sprite : Sprite = $Visuals/Sprite
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var tree_detector : CircleTreeDetector = $TreeDetector
onready var pickup_hint : ButtonHintActivator = $PickupHintActivator

func is_lit(v: Vector2) -> bool:
	return (v - global_position).length() < current_radius

func _ready():
	LightZoneManager.add_light_source(self)
	pickup_hint.conditions_met_ref = funcref(self, "can_be_piicked")
	pickup_hint.action = "use"
	pickup_hint.connect("action_just_pressed", self, "pick_up")
	prepare_noise()
	tree_detector.set_shape_radius(FULL_RADIUS * 3)
	reset()


func reset():
	fire_effect.add_sparks()
	active = true
	start_time = OS.get_ticks_msec()
	GameManager.player_reset_torch(FULL_LIFETIME)


func put_out_fire():
	active = false
	emit_signal("finished")


# TODO: monstrous func, better split into multiples
func _process(delta):
	update()
	if not active:
		current_radius = 0.0
		light.texture_scale = 0.05
		tree_detector.update_trees(0)
		fire_effect.fire = false
		return 
	
	var elapced = (OS.get_ticks_msec() - start_time) / 1000
	
	if elapced < TIME_BEFORE_FLICKER:
		var elapced_percent = elapced / TIME_BEFORE_FLICKER
		current_radius = FLIKER_RADIUS + (FULL_RADIUS - FLIKER_RADIUS) * (1 - elapced_percent)
		light.energy = 1.0
	elif elapced < FULL_LIFETIME:
		var elapced_percent = (elapced - TIME_BEFORE_FLICKER) / FLIKER_LIFETIME
		current_radius = MIN_RADIUS + (FLIKER_RADIUS - MIN_RADIUS) * (1 - elapced_percent)
		light.energy = 1.0 - get_flickering() - elapced_percent / 4
	else:
		active = false
		emit_signal("finished")
	
	fire_effect.fire = true
	light.texture_scale = LIGHT_TEXTURE_SCALE * current_radius
	tree_detector.update_trees(current_radius)


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
	on_the_ground = false
	GameManager.player_picked_torch()
	emit_signal("collected", self)
	
#	looks OK without this transition to me
#	tween.interpolate_property(self, "global_position", 
#		global_position, GameManager.player_position, 
#		0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
#	tween.connect("tween_completed", self, "tween_completed")
#	tween.start()


func can_be_piicked() -> bool:
	return active and on_the_ground and can_pickup_ref.call_func()


func get_flickering() -> float:
	var time = OS.get_ticks_msec()
	return (noise.get_noise_2d(time, 0) + 1) / 5

func _draw():
#	Drawing.draw_circle(self, current_radius, Color.white)
#	Drawing.draw_circle(self, FULL_RADIUS, Color.red)
	pass

func prepare_noise():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.persistence = 0.7
	noise.octaves = 1.0
	noise.period = 30
