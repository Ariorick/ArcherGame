extends RigidBody2D
class_name Enemy

var arrows: Array
var should_release_arrows = false
var is_pulled := false
var pull_target : Node2D

var target: Node2D
var other_enemies: Array = []
var in_range: bool = false

var conditions_changed = true
var is_dead := false

# init this in _on_ready()
var tag: String
var hitpoints: int

# override this
func _on_take_damage():
	pass

# returns true if is stuck
func arrow_entered(arrow: Arrow) -> bool:
	apply_impulse(Vector2.ZERO, arrow.linear_velocity * arrow.mass)
	var arrow_velocity = arrow.linear_velocity.length()
	var is_stuck = arrow_velocity > 100
	if is_stuck:
		arrows.append(arrow)
		var damage = int(arrow_velocity)
		var is_crit = damage > 300
		if is_crit:
			apply_impulse(Vector2.ZERO, arrow.linear_velocity * arrow.mass * 2)
			
		$DeathParticles.process_material.direction = Vector3(arrow.linear_velocity.normalized().x, arrow.linear_velocity.normalized().y, 0)
		$DeathParticles.amount = 5
		if is_crit:
			$DeathParticles.amount = 30
		$DeathParticles.emitting = true
		take_damage(damage, is_crit)
		return true
	else :
		return false

func set_pulled(pulled: bool, target: Node2D):
	is_pulled = pulled
	pull_target = target

func connect_signals(vision: Area2D, attack_radius: Area2D, damage_detector: Area2D):
	vision.connect("body_entered", self, "_on_Vision_body_entered")
	vision.connect("body_exited", self, "_on_Vision_body_exited")
	attack_radius.connect("body_entered", self, "_on_AttackRadius_body_entered")
	attack_radius.connect("body_exited", self, "_on_AttackRadius_body_exited")
#	damage_detector.connect("body_entered", self, "_on_DamageDetector_body_entered")

func take_damage(damage: int, crit = false):
	print(tag, " got ",  damage, " damage")
	$FCTMgr.show_value(damage, crit)
	if crit:
		should_release_arrows = true
	_on_take_damage()
	hitpoints -= damage
	if hitpoints <= 0:
		die()

func die():
	$HitboxBody/Hitbox.disabled = true
	$HitboxBody.collision_layer = 0
	set_modulate(Color(1,1,1,0.4))
	is_dead = true
	should_release_arrows = true

func release_arrows():
	for arrow in arrows:
		if arrow != null:
			arrow.release()
	arrows.clear()

func _on_Vision_body_entered(body: PhysicsBody2D):
	if body.is_in_group("player"):
		target = body
		conditions_changed = true
	if body.is_in_group("enemies") and body != self:
		other_enemies.append(body)

func _on_Vision_body_exited(body: PhysicsBody2D):
	if body == target:
		target = null
		conditions_changed = true
	if body.is_in_group("enemies"):
		other_enemies.erase(body)

func _on_AttackRadius_body_entered(body):
	if body.is_in_group("player"):
		in_range = true
		conditions_changed = true

func _on_AttackRadius_body_exited(body):
	if body.is_in_group("player"):
		in_range = false
		conditions_changed = true

#func move_and_slide(linear_velocity: Vector2, up_direction: Vector2 = Vector2( 0, 0 ), stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398, infinite_inertia: bool = true):
#	body_velocity = .move_and_slide(linear_velocity, up_direction, stop_on_slope, max_slides, floor_max_angle, infinite_inertia)

func get_args() -> Dictionary:
	var args = {
		Action.Args.body: self
	}
	return args
