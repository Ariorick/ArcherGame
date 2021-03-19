extends Node2D
class_name EnemyAction

onready var body: RigidBody2D = get_parent().get_parent().get_parent()
onready var sensors: Sensors = get_parent().get_parent().get_node(NodePath("Sensors"))

# override this
func want_to_start() -> bool:
	return false

# override this
func perform():
	pass

# override this
func is_finished() -> bool:
	return true

# override this
func is_interruptable() -> bool:
	return true

# override this
func cancel():
	pass

