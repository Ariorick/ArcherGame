extends RigidBody2D
class_name Arrow

const AUTO_AIM_STRENGTH = 100.0
const PULL_AUTO_AIM_MODIFIER = 2.0
const AUTO_AIM_ANGLE_TRESHOLD = PI/4
const PULL_AUTO_AIM_ANGLE_TRESHOLD = PI/3

const PULL_STRENGTH = 1500
const LINEAR_DAMP = 1.0
const PULL_LINEAR_DAMP = 1.0

var initial_position: Vector2
var initial_angle: float = 0
var started : = false
var last_force := Vector2()

var auto_aim_treshold = AUTO_AIM_ANGLE_TRESHOLD
var auto_aim_strength_modifier = 1.0

var is_pulled = false
var pull_target: Node2D

var creation_time : int

func _ready():
	visible = false
	creation_time = OS.get_ticks_msec()
	
	# Enable the logging of 5 collisions.
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	
	# Apply Godot physics at first
	set_use_custom_integrator(false) 

func _process(delta: float):
	var energy = linear_velocity.length() / 150
	$Light2D.energy = clamp(energy, 0.3, 1.5)
	$PullParticles.emitting = is_pulled
	update()
	
	# remove this to go back to usual pull behaviour
	if started and  linear_velocity.length() < 10:
		set_pulled(true)

func _draw():
#	draw_global_vector(linear_velocity, Color.white)
	for enemy in $EnemyDetector.enemies:
		var direction_to = enemy.global_position - global_position
#		draw_global_vector(direction_to, Color.aquamarine)
	
	

func draw_global_vector(vector: Vector2, color: Color):
	draw_line(Vector2.ZERO, vector.rotated(-rotation) / 5, color)

func draw_local_vector(vector: Vector2, color: Color):
	draw_line(Vector2.ZERO, vector / 5, color)

func set_pull_target(pull_target: Node2D):
	self.pull_target = pull_target

func set_pulled(pulled: bool):
	is_pulled = pulled
	update_variables(pulled)
	if not pulled:
		add_force(Vector2(), -1* last_force)
		last_force = Vector2()

func update_variables(pulled: bool):
	if pulled:
		linear_damp = PULL_LINEAR_DAMP
		auto_aim_treshold = PULL_AUTO_AIM_ANGLE_TRESHOLD
		auto_aim_strength_modifier = PULL_AUTO_AIM_MODIFIER
	else:
		linear_damp = LINEAR_DAMP
		auto_aim_treshold = AUTO_AIM_ANGLE_TRESHOLD
		auto_aim_strength_modifier = 1.0

func _integrate_forces(body_state: Physics2DDirectBodyState):
	if started:
		visible = true
	
	if not started: 
		started = true
		body_state.transform = Transform2D(initial_angle + PI/4, initial_position)
	
	if body_state.get_contact_count() == 1 :
		stick_to_body(body_state)
		
	pull()

func stick_to_body(body_state: Physics2DDirectBodyState):
	var encountered_body = body_state.get_contact_collider_object(0)
	if encountered_body.is_in_group("enemy_hitbox"):
		var enemy = encountered_body.get_parent().get_parent()
		enemy.arrow_entered(self)

func pull():
	var force = Vector2.ZERO
	var turn_strength = 0.0
	var turn_direction := linear_velocity.normalized()
	
	if is_pulled:
		var to_target =  (pull_target.global_position + pull_target.PLAYER_CENTER) - global_position
		var direction = to_target.normalized()
		var pull_strength = clamp(PULL_STRENGTH / to_target.length() * 15, 300, 3000)
		
		turn_strength = pull_strength
		turn_direction += direction
		force += direction * pull_strength
	
	var target_enemy = get_enemy_at_least_angle()
	if target_enemy != null and linear_velocity.length() > 20:
		var enemy_vector = (target_enemy.global_position - global_position).normalized()
		var angle_to_enemy = abs(enemy_vector.angle_to(linear_velocity))
		if angle_to_enemy < auto_aim_treshold:
			var angle_strength = 1 - angle_to_enemy / AUTO_AIM_ANGLE_TRESHOLD
			var direction_sign = sign(enemy_vector.angle_to(linear_velocity))
			
			var correction_force = AUTO_AIM_STRENGTH * auto_aim_strength_modifier * linear_velocity.length() / 100 * angle_strength
			var correction_vector = linear_velocity.tangent().normalized() * direction_sign * correction_force
			
			var direction = (force + correction_vector).normalized()
			force += correction_vector
			turn_strength += correction_force / 10
			turn_direction += direction
	
	last_force = pull_arrow(last_force, force)
	turn_arrow(-1 * turn_direction, turn_strength)

func angle_difference(v1: Vector2, v2: Vector2) -> float:
	return v1.normalized().angle_to(v2.normalized())

func reduce_angle_to_PI(rad: float) -> float:
	while rad > PI:
		rad -= PI
	while rad < -PI:
		rad += PI
	return rad

func pull_arrow(last_force, force) -> Vector2:
	force *= mass
	add_force(Vector2(), last_force * -1)
	add_force(Vector2(), force)
	return force

func turn_arrow(to_target, pull_strength):
	var tail_position = global_position - $Tail.global_position
	var desired_direction = to_target.normalized()
	var strength = (tail_position.normalized() + desired_direction).length() * sqrt(mass)
	tail_position.normalized() - desired_direction
	var angle_to_target = desired_direction.normalized().angle_to(tail_position)
	apply_torque_impulse(angle_to_target * strength * pull_strength / 50)

func get_enemy_at_least_angle() -> Node2D:
	var enemy_at_least_angle
	var least_angle = 1000
	for enemy in $EnemyDetector.enemies:
		var direction_to = enemy.global_position - global_position
		var angle_difference = abs(direction_to.angle_to(linear_velocity))
		if angle_difference < least_angle:
			enemy_at_least_angle = enemy
			least_angle = angle_difference
	return enemy_at_least_angle
