extends Node2D
class_name HealthManager

const DEFAULT_INVINSIBILITY = 0.5

signal on_death

var hitpoints: int
var invinsibility_end_time = -1000

func take_directional_damage(damage: int, direction: Vector2, crit = false):
	if is_invinsible():
		return
	$DamageParticles.process_material.direction = Vector3(direction.x, direction.y, 0)
	$DamageParticles.amount = 10
	if crit:
		$DamageParticles.amount = 30
	$DamageParticles.emitting = true
	take_damage(damage, crit)


func take_damage(damage: int, crit = false):
	if is_invinsible():
		return
	start_invinsibility(DEFAULT_INVINSIBILITY)
	$ColorAnimationPlayer.play("EnemyTakeDamage")
	$DamageLabels.show_value(damage, crit)
	hitpoints -= damage
	if hitpoints <= 0:
		emit_signal("on_death")

func is_invinsible():
	return invinsibility_end_time > OS.get_ticks_msec()

func start_invinsibility(duration_sec: float):
	invinsibility_end_time = OS.get_ticks_msec() + duration_sec * 1000
