extends Node2D
class_name CircleFire

const RADIUS = 100.0
const TEXTURE_SCALE = 0.0035
const INACTIVE_RADIUS = 0.3
const MIN_ACTIVE_RADIUS = 0.5
const ACTIVATION_RADIUS = MIN_ACTIVE_RADIUS + 0.1
const NARROW_TIME = 60
const TWITCH_RADIUS = 0.15

var active = false
var player_near: bool = false

func is_lit(v: Vector2) -> bool:
	return (v - global_position).length() < RADIUS

func _ready():
	$TreeDetector.update_trees(RADIUS)
	LightZoneManager.add_light_source(self)

func _process(delta):
	update()
#	This line might not be necessary
	$TreeDetector.update_trees(RADIUS)


func can_refill_torch() -> bool:
	return not active


func refill_torch():
	GameManager.player.refill_torch()


func _on_PlayerEnteredDetector_body_entered(body):
	if body is Player:
		pass


func _on_PlayerExitedDetector_body_exited(body):
	if body is Player:
		refill_torch()
