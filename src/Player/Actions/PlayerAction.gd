class_name PlayerAction

var body: KinematicBody2D

enum Args {
	body
}

func _init(args: Dictionary):
	body = args[Args.body]

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

func get_node(path: NodePath) -> Node:
	return body.get_node(path)

