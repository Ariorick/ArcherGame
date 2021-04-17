extends Node2D
class_name HealthManager

const DEFAULT_INVINSIBILITY = 0.5

signal on_death

var hitpoints: int
var invinsibility_end_time = -1000

onready var body: RigidBody2D = get_parent()

func take_directional_damage(damage: int, direction: Vector2):
	if is_invinsible():
		return
	body.apply_impulse(Vector2.ZERO, damage * 10.0 * direction.normalized())
	$DamageParticles.process_material.direction = Vector3(direction.x, direction.y, 0)
	$DamageParticles.amount = damage
	$DamageParticles.process_material.initial_velocity = damage * 10.0/7.0
	$DamageParticles.emitting = true
	take_damage(damage)


func take_damage(damage: int):
	if is_invinsible():
		return
	start_invinsibility(DEFAULT_INVINSIBILITY)
	$ColorAnimationPlayer.stop(true)
	$ColorAnimationPlayer.play("EnemyTakeDamage")
	$DamageLabels.show_value(damage)
	hitpoints -= damage
	if hitpoints <= 0:
		emit_signal("on_death")

func is_invinsible():
	return invinsibility_end_time > OS.get_ticks_msec()

func start_invinsibility(duration_sec: float):
	invinsibility_end_time = OS.get_ticks_msec() + duration_sec * 1000
