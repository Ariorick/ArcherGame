extends RigidBody2D
class_name EnemyBase

signal on_enemy_death

var arrows: Array
var should_release_arrows = false
var is_pulled := false
var pull_target : Node2D

var is_dead := false

# init this in _on_ready()
var tag: String
var damage_treshold: int

func _physics_process(delta):
	if should_release_arrows:
		release_arrows()
		should_release_arrows = false

# returns true if is stuck
func arrow_entered(arrow: Arrow):
	var arrow_impact = arrow.linear_velocity * arrow.mass
	apply_impulse(Vector2.ZERO, arrow_impact)
	var arrow_velocity = arrow.linear_velocity.length()
	var damaged = arrow_velocity > damage_treshold
	
	if damaged:
		var damage = int(arrow_velocity)
		$HealthManager.take_directional_damage(damage, arrow.linear_velocity.normalized())
#		arrow.apply_impulse(Vector2.ZERO, -arrow_impact * 1)


func set_pulled(pulled: bool, target: Node2D):
	is_pulled = pulled
	pull_target = target

func take_damage(damage: int, crit = false):
	$HealthManager.take_damage(damage, crit)

func release_arrows():
	for arrow in arrows:
		if arrow != null:
			add_force(Vector2(), -1* arrow.last_force)
			arrow.release()
	arrows.clear()

func _on_HealthManager_on_death():
	GameManager.enemy_died()
	$Character/CharacterBody/Hitbox.disabled = true
	$Character/CharacterBody.collision_layer = 0
	set_modulate(Color(1,1,1,0.4))
	$Brain.is_dead = true
	is_dead = true
	should_release_arrows = true
	emit_signal("on_enemy_death")
	$QueueFreeTimer.start()

func set_hitpoints(value: int):
	$HealthManager.hitpoints = value


func _on_QueueFreeTimer_timeout():
	queue_free()
