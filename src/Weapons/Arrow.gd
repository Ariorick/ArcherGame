extends RigidBody2D
class_name Arrow

var initial_position: Vector2
var initial_angle: float = 0
var started : = false
var need_to_reset_position : = false
var saved_global_transform : Transform2D

var is_stuck = false

func get_stuck(new_parent: Node2D):
	if is_stuck: 
		return
	is_stuck = true
	set_bounce(0.0)
	linear_velocity = Vector2()
	need_to_reset_position = true
	saved_global_transform = get_global_transform()
	
	
	$CollisionShape2D.queue_free()
	get_parent().remove_child(self)
	new_parent.add_child(self)
	
	set_global_transform(saved_global_transform)

func _ready():
	visible = false
	set_bounce(0.7)
	pass # Replace with function body.

func _integrate_forces(state):
	if not started: 
		started = true
		state.transform = Transform2D(initial_angle + PI/4, initial_position)
		visible = true
	
	if need_to_reset_position:
		state.transform = Transform2D(initial_angle + PI/4, Vector2())
		need_to_reset_position = false
