extends Enemy

var last_attack_time = -100000
var action: Action

func _ready():
	tag = "Skeleton"
	hitpoints = 700
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
	if in_range and OS.get_ticks_msec() - last_attack_time > JumpAttackAction.ACTION_LENGTH:
		last_attack_time = OS.get_ticks_msec()
		action = JumpAttackAction.new(get_args(), target)
	elif target != null:
		action = FollowTargetAction.new(get_args(), target)
	else :
		action = Action.new(get_args())

