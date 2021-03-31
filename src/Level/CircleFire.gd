extends Node2D
class_name CircleFire

const TEXTURE_SCALE = 0.004

var circle: Circle setget set_circle

var active = false
var player_near: bool = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("use"):
		if not active and player_near:
			activate()

func activate():
	active = true
	circle.activate()
	$EnemySpawner.set_process(true)

func circle_updated():
	$Light2D.texture_scale = TEXTURE_SCALE * circle.radius * circle.current_radius / circle.radius
	pass

func set_circle(value):
	circle = value
	circle.connect("circle_updated", self, "circle_updated")


func _on_PlayerDetector_body_entered(body):
	if body is Player:
		player_near = true
		$FireSprite.scale = Vector2(2, 2)

func _on_PlayerDetector_body_exited(body):
	if body is Player:
		player_near = false
		$FireSprite.scale = Vector2(1, 1)
