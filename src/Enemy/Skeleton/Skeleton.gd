extends KinematicBody2D

var target: Node2D
var attack_target # Vector2
var in_range: bool = false

var velocity = Vector2.ZERO

const ATTACK_LENGTH = 800
const ATTACK_PAUSE = 400
var last_attack_time = -100000

var conditions_changed = true
var action: Action

var hitpoints = 2000

func _physics_process(delta):
	if in_range:
		attack_target = target.global_position
	
	if conditions_changed and action != null and action.is_interruptable():
		action.interrupt()
		action = null
	
	if action != null:
		if action.is_finished():
			conditions_changed = true
			action = null
	
	
	if conditions_changed and action == null:
		resolve_action()
		conditions_changed = false
	
	action.perform()

func resolve_action():
	if in_range and OS.get_ticks_msec() - last_attack_time > JumpAttackAction.ACTION_LENGTH:
		last_attack_time = OS.get_ticks_msec()
		action = JumpAttackAction.new(get_args(), attack_target)
	elif target != null:
		action = FollowTargetAction.new(get_args(), target)
	else :
		action = Action.new(get_args())



func _on_Vision_body_entered(body: PhysicsBody2D):
	if body is Player:
		target = body
		conditions_changed = true

func _on_Vision_body_exited(body: PhysicsBody2D):
	if body == target:
		target = null
		conditions_changed = true

func _on_AttackArea_body_entered(body):
	if body is Player:
		in_range = true
		conditions_changed = true

func _on_AttackArea_body_exited(body):
	if body is Player:
		attack_target = null
		in_range = false
		conditions_changed = true

func get_args() -> Dictionary:
	var args = {
		Action.Args.body: self
	}
	return args


func _on_DamageDetector_body_entered(body): 
	if body.linear_velocity.length() > 150:
		if body is Arrow:
			hitpoints -= body.linear_velocity.length()
			print("skeleton got ",  body.linear_velocity.length(), " damage")
			if hitpoints < 0:
				set_modulate(Color(1,1,1,0.5))
				set_physics_process(false)
			$ColorAnimationPlayer.play("EnemyTakeDamage")
			body.get_stuck($Sprite)
		
