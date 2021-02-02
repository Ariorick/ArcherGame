extends RigidBody2D
class_name Arrow

const PULL_STRENGTH = 800

var initial_position: Vector2
var initial_angle: float = 0
var started : = false
var need_to_reset_position : = false
var saved_global_transform : Transform2D
var last_force := Vector2()

var is_stuck = false
var is_pulled = false
var pull_target: Node2D

var creation_time : int

func _ready():
	visible = false
	set_bounce(0.7)
	creation_time = OS.get_ticks_msec()

func set_pull_target(pull_target: Node2D):
	self.pull_target = pull_target

func set_pulled(pulled: bool):
	if not is_stuck:
		is_pulled = pulled
		if not pulled:
			add_force(Vector2(), -1* last_force)
			last_force = Vector2()

func get_stuck(new_parent: Node2D, velocity: Vector2):
	if is_stuck: 
		return
	is_stuck = true
	
	linear_velocity = Vector2()
	angular_velocity = 0.0
	set_bounce(0.0)
	saved_global_transform = get_global_transform()
	$CollisionShape2D.queue_free()
	get_parent().remove_child(self)
	
	new_parent.add_child(self)
	set_global_transform(saved_global_transform)
	set_mode(MODE_STATIC)
	set_sleeping(true)

func _physics_process(delta):
	if is_pulled:
		var to_target = global_position - (pull_target.global_position + Vector2(0, 1.9))
		var direction = -1 * to_target.normalized()
		var pull_strength = clamp(PULL_STRENGTH / to_target.length() * 15, 300, 2000)
		var force = direction * pull_strength
		print (force.length())
		add_force(Vector2(), last_force * -1)
		add_force(Vector2(), force)
		last_force = force
		
		
		var tail_position = global_position - $Tail.global_position
		var desired_direction = to_target.normalized()
		var strength = (tail_position.normalized() + desired_direction).length()
		tail_position.normalized() - desired_direction
		var angle_to_target = desired_direction.normalized().angle_to(tail_position)
		apply_torque_impulse(angle_to_target * strength * pull_strength / 50)

func _integrate_forces(state: Physics2DDirectBodyState):
	if started:
		visible = true
	
	if not started: 
		started = true
		state.transform = Transform2D(initial_angle + PI/4, initial_position)
