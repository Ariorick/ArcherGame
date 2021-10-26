extends Node2D
class_name ButtonHintActivator

signal action_just_pressed

export var button_text : String = "" setget set_button_text, get_button_text
export var goal_text : String  setget set_goal_text, get_goal_text
export var need_to_hold: bool setget set_need_to_hold, get_need_to_hold

var conditions_met_ref: FuncRef
var action: String

var player_near: bool = false

func _process(delta):
	if is_active():
		$ButtonHint.show()
	else: 
		$ButtonHint.hide()

func _unhandled_input(event):
	if Input.is_action_just_pressed(action) and is_active():
		emit_signal("action_just_pressed")

func is_active():
	return player_near and conditions_met_ref.call_func()

func _on_PlayerDetector_body_entered(body):
	if body is Player:
		player_near = true

func _on_PlayerDetector_body_exited(body):
	if body is Player:
		player_near = false

func set_button_text(value):
	$ButtonHint.button_text =  value

func get_button_text() -> String:
	return $ButtonHint.button_text

func set_goal_text(value):
	$ButtonHint.goal_text =  value

func get_goal_text() -> String:
	return $ButtonHint.goal_text

func set_need_to_hold(value):
	$ButtonHint.need_to_hold =  value

func get_need_to_hold() -> bool:
	return $ButtonHint.need_to_hold
