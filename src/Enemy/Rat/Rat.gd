extends KinematicBody2D
class_name Rat

var target: Node2D
var attack_target # Vector2
var in_range: bool = false

var velocity = Vector2.ZERO

var other_enemies: Array = []
var last_attack_time = -100000

var conditions_changed = true
var action: Action

var hitpoints = 2

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
	if in_range and OS.get_ticks_msec() - last_attack_time > BiteAttackAction.ACTION_LENGTH:
		last_attack_time = OS.get_ticks_msec()
		action = BiteAttackAction.new(get_args(), target)
	elif target != null:
		action = SpreadAndFollowAction.new(get_args(), target, other_enemies)
	else :
		action = Action.new(get_args())


func idle():
	velocity = Vector2()

func _on_Vision_body_entered(body: PhysicsBody2D):
	if body is Player:
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
	if body.linear_velocity.length() > 20:
		$ColorAnimationPlayer.play("EnemyTakeDamage")
		if body is Arrow:
			body.get_stuck($Sprite)
			hitpoints -= 1
			if hitpoints == 0:
				queue_free()
		
