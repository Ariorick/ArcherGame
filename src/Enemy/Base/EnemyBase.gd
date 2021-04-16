extends RigidBody2D
class_name EnemyBase

signal on_enemy_death
var is_dead := false

# init this in _on_ready()
var tag: String
var damage_treshold: int

# returns true if is stuck
func arrow_entered(arrow: Arrow):
	var arrow_velocity = arrow.linear_velocity.length()
	var damage = int(arrow_velocity / 10)
	var damaged = damage > damage_treshold
	
	if damaged:
		$HealthManager.take_directional_damage(damage, arrow.linear_velocity.normalized())


func take_directional_damage(damage: int, impulse: Vector2):
	$HealthManager.take_directional_damage(damage, impulse)

func take_damage(damage: int):
	$HealthManager.take_damage(damage)


func _on_HealthManager_on_death():
	GameManager.enemy_died()
	$Character/CharacterBody/Hitbox.disabled = true
	$Character/CharacterBody.collision_layer = 0
	set_modulate(Color(1,1,1,0.4))
	$Brain.is_dead = true
	is_dead = true
	emit_signal("on_enemy_death")
	$QueueFreeTimer.start()

func set_hitpoints(value: int):
	$HealthManager.hitpoints = value

func _on_QueueFreeTimer_timeout():
	queue_free()
