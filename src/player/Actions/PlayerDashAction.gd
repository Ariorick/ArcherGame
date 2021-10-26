extends PlayerAction
class_name PlayerDashAction

const DASH_TIMEOUT = 700
const DASH_TIME = 180
const DASH_SPEED = 300

var last_dash_time = -10000
var dash_direction := Vector2()
var started = false
var finished = false

func _init(args: Dictionary).(args):
	pass

func want_to_start() -> bool:
	var dash_available = (
		OS.get_ticks_msec() - last_dash_time > DASH_TIMEOUT 
		and PlayerInput.get_direction().length() != 0
		and GameManager.can_dash()
	)
	return Input.is_action_just_pressed("dash") and dash_available

func perform():
	if not started:
		started = true
		dash_direction = PlayerInput.get_direction()
		last_dash_time = OS.get_ticks_msec()
		
		var velocity = dash_direction * DASH_SPEED
		$DashParticles2.process_material.angle = rad2deg(-1 * dash_direction.angle() - PI/4)
		$DashParticles.emitting = true
		$DashParticles2.emitting = true
		body.apply_impulse(Vector2(), velocity)
	
	if OS.get_ticks_msec() - last_dash_time > DASH_TIME:
		$DashParticles.emitting = false
		$DashParticles2.emitting = false
		finished = true
		return

func cancel():
	dash_direction = Vector2()
	finished = false
	started = false

func is_finished() -> bool:
	return finished

func is_interruptable() -> bool:
	return false
