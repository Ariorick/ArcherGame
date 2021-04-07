extends Node2D
class_name CircleFire

const TEXTURE_SCALE = 0.003

var circle: Circle setget set_circle

var active = false
var player_near: bool = false

func _ready():
	$EnemySpawner.connect("level_finished", self, "level_finished")
	$EnemySpawner.connect("enemy_died", self, "enemy_died")

func activate():
	active = true
	circle.activate()
	$EnemySpawner.set_program(circle.program)
	$EnemySpawner.set_process(true)
	$MinRadiusParticles.emitting  = true

func level_finished():
	circle.finish()

func enemy_died():
	circle.twitch()

func _process(delta):
	$EnemySpawner.spawn_radius = circle.current_radius
	if not active and player_near:
		 $FireSprite.scale = Vector2(2, 2)
	else:
		$FireSprite.scale = Vector2(1, 1)

func _unhandled_input(event):
	if Input.is_action_just_pressed("use"):
		if not active and player_near:
			activate()

func circle_updated():
	$Light2D.texture_scale = TEXTURE_SCALE * circle.radius * circle.current_radius / circle.radius
	pass

func set_circle(value):
	circle = value
	circle.connect("circle_updated", self, "circle_updated")
	
	var particles_scale = circle.radius / 180.0 * Circle.MIN_ACTIVE_RADIUS
	var particles_position = particles_scale * -250.0
	$MinRadiusParticles.scale = Vector2(particles_scale, particles_scale)
	$MinRadiusParticles.position = Vector2(particles_position, particles_position)
	$MinRadiusParticles.process_material.scale = 1/particles_scale

func _on_PlayerDetector1_body_entered(body):
	if body is Player:
		player_near = true

func _on_PlayerDetector1_body_exited(body):
	if body is Player:
		player_near = false
