extends PlayerAction
class_name PlayerDashAction

const DASH_TIMEOUT = 600
const DASH_TIME = 130
const DASH_SPEED = 300

var last_dash_time = -10000
var dash_direction := Vector2()
var finished = false

func _init(args: Dictionary).(args):
	pass

func want_to_start() -> bool:
	var dash_available = (
		OS.get_ticks_msec() - last_dash_time > DASH_TIMEOUT 
		and PlayerInput.get_direction().length() != 0
	)
	return Input.is_action_just_pressed("dash") and dash_available

func perform():
	if Input.is_action_just_pressed("dash"):
		dash_direction = PlayerInput.get_direction()
		last_dash_time = OS.get_ticks_msec()
	
	if OS.get_ticks_msec() - last_dash_time > DASH_TIME:
		$DashParticles.emitting = false
		finished = true
		return
	
	var velocity = dash_direction * DASH_SPEED
	$DashParticles.emitting = true
	body.move_and_slide(velocity)

func cancel():
	dash_direction = Vector2()
	finished = false

func is_finished() -> bool:
	return finished

func is_interruptable() -> bool:
	return false
