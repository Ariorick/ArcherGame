class_name Action

var body: KinematicBody2D

enum Args {
	body
}

func _init(args: Dictionary):
	body = args[Args.body]

func perform():
	pass

func is_finished() -> bool:
	return true

func is_interruptable() -> bool:
	return true

func interrupt():
	pass

func get_node(path: NodePath) -> Node:
	return body.get_node(path)
