extends RigidBody2D
class_name Arrow

const PULL_STRENGTH = 1100
const LINEAR_DAMP = 2.0
const PULL_LINEAR_DAMP = 1.2

var initial_position: Vector2
var initial_angle: float = 0
var started : = false
var need_to_reset_position : = false
var saved_global_transform : Transform2D
var last_force := Vector2()


var is_pulled = false
var pull_target: Node2D

var creation_time : int

#######
var is_sticking = false

# rigid body on which the ball will stick
var body_on_which_sticked
var enemy_on_which_sticked

# (used when sticked) Transform (tr) at the collision instant (ci) from the collider to the ball
var tr_ci_collider_to_ball = Transform2D()
########


func _ready():
	visible = false
	creation_time = OS.get_ticks_msec()
	
	# Enable the logging of 5 collisions.
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	
	# Apply Godot physics at first
	set_use_custom_integrator(false) 

func _process(delta: float):
	$PullParticles.emitting = is_pulled

func set_pull_target(pull_target: Node2D):
	self.pull_target = pull_target

func set_pulled(pulled: bool):
	is_pulled = pulled
	update_linear_damp(pulled)
	if not pulled:
		if is_sticking:
			enemy_on_which_sticked.add_force(Vector2(), -1* last_force)
		else:
			add_force(Vector2(), -1* last_force)
		last_force = Vector2()
	
	if is_sticking:
		enemy_on_which_sticked.set_pulled(pulled, pull_target)

func update_linear_damp(pulled: bool):
	if pulled:
		linear_damp = PULL_LINEAR_DAMP
	else:
		linear_damp = linear_damp

func release():
	var new_position = enemy_on_which_sticked.global_position
	is_sticking = false
	enemy_on_which_sticked = null
	body_on_which_sticked = null
	tr_ci_collider_to_ball = Transform2D()
	set_use_custom_integrator(false)
	started = false
	visible = false
	last_force = Vector2.ZERO
	
	linear_velocity = Vector2.ZERO
	applied_force = Vector2.ZERO
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	initial_angle = rng.randf_range(-PI, PI)
	initial_position = new_position
	var impulse = Vector2(cos(initial_angle), sin(initial_angle)) * 35 * mass
	apply_impulse(Vector2(0, 0), impulse)

func _integrate_forces(body_state: Physics2DDirectBodyState):
	if started:
		visible = true
	
	if not started: 
		started = true
		body_state.transform = Transform2D(initial_angle + PI/4, initial_position)
	
	if is_sticking == false && body_state.get_contact_count() == 1 :
		stick_to_body(body_state)
		
	# Behavior when sticking
	if is_sticking:
		# We take the last transform of the moving collider, and we keep the same relative position of the ball to the collider it had at the collision instant.
		# In other words: "world->collider (at latest news), and then, collider->ball (like at the collision instant)".
		global_transform = body_on_which_sticked.get_global_transform() * tr_ci_collider_to_ball
	
	if is_pulled:
		pull()

func pull():
	var to_target = global_position - (pull_target.global_position + pull_target.PLAYER_CENTER)
	var direction = -1 * to_target.normalized()
	var pull_strength = clamp(PULL_STRENGTH / to_target.length() * 15, 300, 3000)
	var force = direction * pull_strength
	if is_sticking:
		last_force = pull_enemy(last_force, direction)
	else :
		last_force = pull_arrow(last_force, force)
		turn_arrow(to_target, pull_strength)

func pull_enemy(last_force, direction) -> Vector2:
	var force = direction * 800
	enemy_on_which_sticked.add_force(Vector2(), last_force * -1)
	enemy_on_which_sticked.add_force(Vector2(), force)
	return force

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


func stick_to_body(body_state: Physics2DDirectBodyState):
	body_on_which_sticked = body_state.get_contact_collider_object(0)
	if body_on_which_sticked.is_in_group("enemy_hitbox"):
		enemy_on_which_sticked = body_on_which_sticked.get_parent().get_parent()
		is_sticking = enemy_on_which_sticked.arrow_entered(self)
	if not is_sticking:
		return
	
	# Ignore Godot physics once the ball sticks
	set_use_custom_integrator(true) 
	
	print("The Arrow is sticking on a ", enemy_on_which_sticked.get_name())

	# Some transforms (tr) at the collision instant (ci)
	var tr_ci_world_to_ball = get_global_transform() # from the world coordinate system to the ball coordinate system
	var tr_ci_world_to_collider = body_on_which_sticked.get_global_transform()
	
	# remove scale
	var scale_reverse = Vector2(1, 1) / tr_ci_world_to_collider.get_scale()
	tr_ci_world_to_collider = Transform2D(0, tr_ci_world_to_collider.get_origin() / scale_reverse).scaled(scale_reverse)
	
	# from the world cs to the collider cs
	tr_ci_collider_to_ball = tr_ci_world_to_collider.inverse() * tr_ci_world_to_ball # Because: collider->ball = collider->world then world->ball = inverse(world->collider) then world->ball
