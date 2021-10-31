extends Interactable
class_name CircleFire

const RADIUS = 150.0
const TEXTURE_SCALE = 0.0035

var active = false
var player_near: bool = false

func is_lit(v: Vector2) -> bool:
	return (v - global_position).length() < RADIUS

func _ready():
	$TreeDetector.update_trees(RADIUS)
	LightZoneManager.add_light_source(self)
	$FireSprite.material.set_shader_param("enabled", true)
	update_state()

func _process(delta):
	update()
#	This line might not be necessary
	$TreeDetector.update_trees(RADIUS)

func update_state():
	if close_to_player:
		$FireSprite.material.set_shader_param("color", Color(1, 1, 1, .25))
		if mouse_hovered:
			$FireSprite.material.set_shader_param("color", Color(1, 1, 1, .6))
	else:
		$FireSprite.material.set_shader_param("color", Color(1, 1, 1, 0))


func can_refill_torch() -> bool:
	return not active


func refill_torch():
	GameManager.player.refill_torch()


func _on_PlayerEnteredDetector_body_entered(body):
	if body is Player:
		Saver.save_game()


func _on_PlayerExitedDetector_body_exited(body):
	if body is Player:
		refill_torch()
		Saver.save_game()


func _on_CircleFire_clicked(close_to_player):
	if close_to_player:
		pass # open craft


func _on_CircleFire_state_changed(is_hovered, close_to_player):
	update_state()
