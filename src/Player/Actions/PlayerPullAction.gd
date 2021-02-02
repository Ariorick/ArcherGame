extends PlayerAction
class_name PlayerPullAction

var get_arrows: FuncRef # () -> Array of Arrow
var finished := false

func _init(args: Dictionary, get_arrows: FuncRef).(args):
	self.get_arrows = get_arrows

func want_to_start() -> bool:
	return Input.is_action_just_pressed("pull") and not get_arrows.call_func().empty()

func perform():
	if Input.is_action_just_pressed("pull"):
		for arrow in get_arrows.call_func():
			arrow.set_pulled(true)
	if Input.is_action_just_released("pull"):
		finished = true

func cancel():
	for arrow in get_arrows.call_func():
		arrow.set_pulled(false)
	finished = false

func is_finished() -> bool:
	return get_arrows.call_func().empty() || finished

func is_interruptable() -> bool:
	return true
