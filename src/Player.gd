extends KinematicBody2D
class_name Player

const Arrow = preload("res://src/Weapons/Arrow.tscn")

const PLAYER_CENTER = Vector2(0, -3.9)
const DASH_TIME = 100
const DASH_TIMEOUT = 600
const SPEED = 80  # speed in pixels/sec
const DASH_SPEED = 300
const ATTACK_TIMEOUT = 1000

var last_dash_time = -10000
var dash_direction: Vector2

var last_attack_time = -10000

func take_damage():
	$ColorAnimationPlayer.play("EnemyTakeDamage")

func _physics_process(delta):
	move()
	attack()

func move(): 
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

func attack():
	var direction = get_attack_direction()
	if direction.length() == 0: 
		return
	
	var attack_available = OS.get_ticks_msec() - last_attack_time > ATTACK_TIMEOUT
	if not attack_available:
		return
	last_attack_time = OS.get_ticks_msec()
	
	var arrow = Arrow.instance()
	var impulse = direction * 250
	arrow.initial_angle = impulse.angle()
	arrow.initial_position = global_position + PLAYER_CENTER
	arrow.apply_impulse(Vector2(0, 0), impulse)
	get_parent().add_child(arrow)

func dash(direction: Vector2):
	var velocity = direction * DASH_SPEED
	$DashParticles.emitting = true
	move_and_slide(velocity)

func walk(direction: Vector2):
	var velocity = direction * SPEED
	$AnimationPlayer.play("Walk")
	$StepParticles/Left.emitting = true
	$StepParticles/Right.emitting = true
	move_and_slide(velocity)


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
