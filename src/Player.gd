extends KinematicBody2D
class_name Player

const Arrow = preload("res://src/Weapons/Arrow.tscn")

const PLAYER_CENTER = Vector2(0, -3.9)
const DASH_TIME = 100
const DASH_TIMEOUT = 600
const SPEED = 80  # speed in pixels/sec
const DASH_SPEED = 300
const ARROW_MAX_VELOCITY = 400
const HOLD_MAX_TIME = 1000.0

var last_dash_time = -10000
var dash_direction: Vector2

var last_aim_direction := Vector2()
var is_aiming := false
var aim_start_time := -10000
var movement_speed_decreasing := 0.0
var current_velocity := Vector2()

func _on_DamageDetector_body_entered(body: PhysicsBody2D):
	if body.is_in_group("enemies"):
		take_damage()

func take_damage():
	$ColorAnimationPlayer.play("EnemyTakeDamage")

func _physics_process(delta):
	move()
	attack()

func move(): 
	current_velocity = Vector2()
	$StepParticles/Left.emitting = false
	$StepParticles/Right.emitting = false
	$DashParticles.emitting = false
	
	if OS.get_ticks_msec() - last_dash_time < DASH_TIME:
		dash(dash_direction)
	
	var direction = get_direction()
	if direction.length() == 0:
		return
	
	var dash_available = OS.get_ticks_msec() - last_dash_time > DASH_TIMEOUT
	if Input.is_action_just_pressed("dash") and dash_available:
		dash_direction = direction
		last_dash_time = OS.get_ticks_msec()
		dash(dash_direction)
	else:
		walk(direction)

func cancel_aim():
	pass

func attack():
	var screen_size := Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height")) 
	var direction := (get_viewport().get_mouse_position() - screen_size / 2).normalized()
	
	if is_aiming and Input.is_action_just_released("attack"):
		is_aiming = false
		var strength = min((OS.get_ticks_msec() - aim_start_time) / HOLD_MAX_TIME, 1)
		var linear_velocity = strength * ARROW_MAX_VELOCITY
		shoot_arrow(direction, linear_velocity, Vector2())
#		shoot_arrow(direction, linear_velocity, current_velocity)
		is_aiming = false
		movement_speed_decreasing = 0.0
		return
	
	if Input.is_action_just_pressed("attack"):
		is_aiming = true
		aim_start_time = OS.get_ticks_msec()
	
	if Input.is_action_pressed("attack"):
		movement_speed_decreasing = min((OS.get_ticks_msec() - aim_start_time) / HOLD_MAX_TIME, 1)
	
	

func shoot_arrow(direction: Vector2, linear_velocity: float, player_velocity: Vector2):
	var arrow = Arrow.instance()
	var impulse = direction * linear_velocity + player_velocity
	arrow.initial_angle = impulse.angle()
	arrow.initial_position = global_position + PLAYER_CENTER
	arrow.apply_impulse(Vector2(0, 0), impulse)
	get_parent().add_child(arrow)

func dash(direction: Vector2):
	var velocity = direction * DASH_SPEED
	$DashParticles.emitting = true
	current_velocity = move_and_slide(velocity)

func walk(direction: Vector2):
	var velocity = direction * SPEED * max(1 - movement_speed_decreasing, 0.2)
	$AnimationPlayer.play("Walk")
	$StepParticles/Left.emitting = true
	$StepParticles/Right.emitting = true
	current_velocity = move_and_slide(velocity)


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength('right') - Input.get_action_strength('left'),
		Input.get_action_strength('down') - Input.get_action_strength('up')
	).normalized()

func get_attack_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("attack_right") - Input.get_action_strength("attack_left"),
		Input.get_action_strength("attack_down") - Input.get_action_strength("attack_up")
	).normalized()

