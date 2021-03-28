extends Node2D
class_name HealthManager

signal on_death

var hitpoints: int

func take_directional_damage(damage: int, direction: Vector2, crit = false):
	$DamageParticles.process_material.direction = Vector3(direction.x, direction.y, 0)
	$DamageParticles.amount = 10
	if crit:
		$DamageParticles.amount = 30
	$DamageParticles.emitting = true
	take_damage(damage, crit)


func take_damage(damage: int, crit = false):
	print(get_parent().tag, " got ",  damage, " damage")
	$ColorAnimationPlayer.play("EnemyTakeDamage")
	$DamageLabels.show_value(damage, crit)
	hitpoints -= damage
	if hitpoints <= 0:
		emit_signal("on_death")
