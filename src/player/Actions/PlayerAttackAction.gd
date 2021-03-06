extends PlayerAction
class_name PlayerAttackAction

const Arrow = preload("res://src/weapons/Arrow.tscn")

const ARROW_FRAMES = 4
const ARROW_MAX_VELOCITY = 400
const MIN_HOLD_TIME = 100.0
const HOLD_MAX_TIME = 600.0

var aim_start_time := -10000
var last_aim_direction := Vector2()
var finished = false

var can_shoot: FuncRef # () -> bool
var on_arrow_fired: FuncRef # (Arrow)

func _init(args: Dictionary, can_shoot: FuncRef, on_arrow_fired: FuncRef).(args):
	self.can_shoot = can_shoot
	self.on_arrow_fired = on_arrow_fired

func want_to_start() -> bool:
	return Input.is_action_just_pressed("aim") and can_shoot.call_func()

func perform():
	if Input.is_action_just_pressed("aim"):
		aim_start_time = OS.get_ticks_msec()
		$BowSprite.frame = 0
	
	var direction = PlayerInput.get_mouse_direction(body)
	var aim_time = OS.get_ticks_msec() - aim_start_time
	$BowSprite.rotation = direction.angle() + PI/4
	$BowSprite.frame = int(aim_time / (HOLD_MAX_TIME / ARROW_FRAMES)) + 1
	
	if Input.is_action_just_released("aim"):
		if aim_time < MIN_HOLD_TIME:
			return
		var strength = min(aim_time / HOLD_MAX_TIME, 1)
		var linear_velocity = strength * ARROW_MAX_VELOCITY
		shoot_arrow(direction, linear_velocity, Vector2())
		$BowSprite.frame = 0
		finished = true

func shoot_arrow(direction: Vector2, linear_velocity: float, player_velocity: Vector2):
#	var arrow = Arrow.instance()
#	var impulse = direction * linear_velocity + player_velocity
#	arrow.initial_angle = impulse.angle()
#	arrow.initial_position = body.global_position + body.PLAYER_CENTER
#	arrow.apply_impulse(Vector2(0, 0), impulse)
#	body.apply_impulse(Vector2(0, 0), -1 * impulse * arrow.mass)
#	body.get_parent().add_child(arrow)
#	on_arrow_fired.call_func(arrow)
	pass

func cancel():
	aim_start_time = -10000
	last_aim_direction = Vector2()
	finished = false
	$BowSprite.frame = 0

func is_finished() -> bool:
	return finished

func is_interruptable() -> bool:
	return true
