extends Node
class_name Brain

var conditions_changed: bool = true
var is_active: bool = true
var current_action: EnemyAction
var possible_actions: Array = Array() # of EnemyAction

func _ready():
	add_actions()
	$Sensors.parent_enemy = get_parent()


func _physics_process(delta):
	if not is_active:
		if current_action != null:
			current_action.cancel()
			current_action == null
		return
		
	if current_action != null and current_action.is_finished():
		current_action.cancel()
		current_action = null
	
	if current_action == null or current_action.is_interruptable():
		for action in possible_actions:
			if action != current_action and action.want_to_start():
				if current_action != null:
					current_action.cancel()
				current_action = action
				break
	
	if current_action != null:
		current_action.perform()

func _on_Sensors_conditions_changed():
	conditions_changed = true

func add_actions():
	for kid in $Actions.get_children():
		if kid is EnemyAction and kid.visible:
			possible_actions.append(kid)

