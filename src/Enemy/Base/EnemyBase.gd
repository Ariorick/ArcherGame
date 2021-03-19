extends RigidBody2D
class_name EnemyBase

var arrows: Array
var should_release_arrows = false
var is_pulled := false
var pull_target : Node2D

var is_dead := false

# init this in _on_ready()
var tag: String = ""

func _physics_process(delta):
	if should_release_arrows:
		release_arrows()
		should_release_arrows = false

# returns true if is stuck
func arrow_entered(arrow: Arrow) -> bool:
	var arrow_impact = arrow.linear_velocity * arrow.mass
	apply_impulse(Vector2.ZERO, arrow_impact)
	var arrow_velocity = arrow.linear_velocity.length()
	var is_stuck = arrow_velocity > 100
	if is_stuck:
		arrows.append(arrow)
		var damage = int(arrow_velocity)
		var is_crit = damage > 300
		if is_crit:
			apply_impulse(Vector2.ZERO, arrow_impact * 2)
			should_release_arrows = true
		$HealthManager.take_directional_damage(damage, arrow.linear_velocity.normalized(), is_crit)
		return true
	else :
		return false

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
	$Character/CharacterBody/Hitbox.disabled = true
	$Character/CharacterBody.collision_layer = 0
	set_modulate(Color(1,1,1,0.4))
	$Brain.is_dead = true
	is_dead = true
	should_release_arrows = true
