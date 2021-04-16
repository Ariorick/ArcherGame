extends Node2D
class_name CircleFire

const TEXTURE_SCALE = 0.003
const INACTIVE_RADIUS = 0.3
const MIN_ACTIVE_RADIUS = 0.5
const ACTIVATION_RADIUS = MIN_ACTIVE_RADIUS + 0.1
const NARROW_TIME = 60
const TWITCH_RADIUS = 0.15

onready var get_torch_hint : ButtonHintActivator = $GetTorchHintActivator

var program: SpawnerProgram
var top_roads: Array = Array()
var bottom_roads: Array = Array()
var radius: float = 100.0 setget set_radius
export var current_radius: float = 70.0

var active = false
var player_near: bool = false

func _ready():
	get_torch_hint.conditions_met_ref = funcref(self, "can_refill_torch")
	get_torch_hint.action = "use"
	get_torch_hint.connect("action_just_pressed", self, "refill_torch")
#	ignite_hint.conditions_met_ref = funcref(self, "can_refill_torch")
#	ignite_hint.action = "use"
#	ignite_hint.connect("action_just_pressed", self, "refill_torch")
	
	$EnemySpawner.connect("level_finished", self, "level_finished")
	$EnemySpawner.connect("enemy_died", self, "enemy_died")
	
#	var particles_scale = circle.radius / 165.0 * Circle.MIN_ACTIVE_RADIUS
#	var particles_position = particles_scale * -256.0
#	$MinRadiusParticles.scale = Vector2(particles_scale, particles_scale)
#	$MinRadiusParticles.position = Vector2(particles_position, particles_position)
#	$MinRadiusParticles.process_material.scale = 1/particles_scale

func _process(delta):
	update()
	$Light2D.texture_scale = TEXTURE_SCALE * current_radius
	$TreeDetector.update_trees(current_radius)
	$EnemySpawner.spawn_radius = current_radius
	
	if GameManager.is_holding_torch:
		get_torch_hint.goal_text = "refill torch"
	else:
		get_torch_hint.goal_text = "take torch"
	
	if not active and player_near:
		 $FireSprite.scale = Vector2(1.5, 1.5)
	else:
		$FireSprite.scale = Vector2(1, 1)

func can_refill_torch() -> bool:
	return not active

func refill_torch():
	GameManager.player.refill_torch()

func activate():
	active = true
	$EnemySpawner.set_program(program)
	$EnemySpawner.set_process(true)
	animate_activation()

func level_finished():
	animate_finish()

func enemy_died():
	animate_twitch()



func _unhandled_input(event):
	if Input.is_action_just_pressed("use"):
		if not active and player_near:
#			activate()
			pass

func _on_ActivationTween_tween_all_completed():
	narrow(current_radius)

func animate_activation():
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

func animate_twitch():
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

func animate_finish():
	$ProcessTween.remove_all()
	$ProcessTween.interpolate_property(self, "current_radius", 
		current_radius, min(current_radius + 1.5, radius), 3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
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


func set_camera_zoom(value):
	CameraManager.zoom = value

func set_camera_offset(value):
	CameraManager.offset = value

func _draw():
	Drawing.draw_circle(self, current_radius, Color.white)
	Drawing.draw_circle(self, radius, Color.red)
	pass


