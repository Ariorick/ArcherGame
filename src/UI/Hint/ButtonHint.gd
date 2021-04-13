extends Control
class_name ButtonHint

export var button_text : String = "" setget set_button_text
export var goal_text : String = ""
export var need_to_hold: bool = false

var active := false

func set_button_text(value):
	button_text = value

func _ready():
	update_label()

func show():
	if not active:
		active = true
		$AnimationPlayer.play("ShowButtonHint")

func hide():
	if active:
		active = false
		$AnimationPlayer.play_backwards("ShowButtonHint")

func update_label():
	var action: String
	if need_to_hold:
		action = "hold"
	else:
		action = "press"
	$Panel/Label.set_text(action + " " + button_text + " to " + goal_text)
