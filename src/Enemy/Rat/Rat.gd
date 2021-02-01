extends Enemy
class_name Rat

var last_attack_time = -100000
var action: Action

func _ready():
	tag = "Rat"
	hitpoints = 300
	connect_signals($Vision, $AttackArea, $DamageDetector)

func _on_take_damage():
	$ColorAnimationPlayer.play("EnemyTakeDamage")

func _physics_process(delta):
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
