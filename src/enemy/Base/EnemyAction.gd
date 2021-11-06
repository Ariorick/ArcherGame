extends Node2D
class_name EnemyAction

onready var brain = get_parent().get_parent()
onready var body: RigidBody2D = brain.get_parent()
onready var sensors: Sensors = brain.get_node(NodePath("Sensors"))
onready var mover: Mover = brain.get_node(NodePath("Mover"))
onready var state: EnemyState = brain.get_node(NodePath("EnemyState"))
onready var navigation: Navigation2D = body.get_parent().get_parent().get_node(NodePath("Navigation2D"))

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

