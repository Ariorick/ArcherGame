extends CanvasLayer

const SURVIVAL_IN_DARKNESS_TIME = 2
const EFFECT_DELAY = 0.4

var current_darkness := 0.0
var is_lit := true

func _process(delta):
	var new_is_lit = LightZoneManager.is_player_lit()
	if is_lit != new_is_lit:
		is_lit = new_is_lit
		$Tween.stop_all()
		if is_lit:
			$Tween.interpolate_method(self, "update_darkness", current_darkness, 0, 
				SURVIVAL_IN_DARKNESS_TIME * current_darkness, 
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, EFFECT_DELAY)
			$Tween.interpolate_method(CameraManager, "set_darkness_shiver_amplitude", 
				current_darkness / 2, 0, SURVIVAL_IN_DARKNESS_TIME * current_darkness, 
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, EFFECT_DELAY)
		else:
			$Tween.interpolate_method(CameraManager, "set_darkness_shiver_amplitude", current_darkness, 1,
				SURVIVAL_IN_DARKNESS_TIME * (1 - current_darkness), Tween.TRANS_LINEAR)
			$Tween.interpolate_method(self, "update_darkness", current_darkness, 1, 
				SURVIVAL_IN_DARKNESS_TIME * (1 - current_darkness), Tween.TRANS_LINEAR)
		
		$Tween.start()

func update_darkness(darkness: float):
	current_darkness = darkness
	$ColorRect.color = get_color(darkness)

func get_color(darkness: float) -> Color:
	return Color(0,0,0, darkness)
