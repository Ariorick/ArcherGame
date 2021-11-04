extends Interactable
class_name CircleFire

const RADIUS = 110.0
const TEXTURE_SCALE = 0.0035

var active = false
var player_near: bool = false

func is_lit(v: Vector2) -> bool:
	return (v - global_position).length() < RADIUS

func _ready():
	$Light2D.texture_scale = TEXTURE_SCALE * RADIUS
	$TreeDetector.update_trees(RADIUS)
	$TreeDetector.set_shape_radius(RADIUS)
	LightZoneManager.add_light_source(self)
	$FireSprite.material.set_shader_param("enabled", true)
	update_state()
	update()

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
	if body is Player and Inventory.instrument_level("torch") > 0:
		refill_torch()
		Saver.save_game()


func _on_CircleFire_clicked(close_to_player):
	if close_to_player:
		UiSignals.open_crafting()


func _on_CircleFire_state_changed(is_hovered, close_to_player):
	update_state()

func _draw():
	Drawing.draw_circle(self, RADIUS, Color.white)
