extends Node2D
class_name Minigame


func on_clicked():
	var y = $Cover.position.y
	var result = 0
	if y > 13:
		pass
	elif y <= 13 and y >= 8:
		result = 3
	elif y < 8 and y >= 0:
		result = 2
	elif y < 0 and y >= -22:
		result = 1
	$AnimationPlayer.stop()



func _unhandled_input(event: InputEvent):
	if Input.is_action_just_pressed("attack"):
		on_clicked()
