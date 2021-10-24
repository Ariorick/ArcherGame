extends Node2D
class_name Minigame

signal sucess(item_count)
signal resource_destroyed()
signal resource_untouched()

var item_id: String
var resource_texture: Texture

var game_in_progress

func _ready():
	$AnimationPlayer.play("init_minigame")
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "init_minigame":
		$AnimationPlayer.play("move_stripe")
		game_in_progress = true
	if anim_name == "close_minigame":
		queue_free()
	

func on_clicked():
	$AnimationPlayer.stop()
	var y = $Stripe.position.y
	var result = 0
	if y < -13:
		result = -1
	elif y >= -13 and y <= -8:
		result = 3
	elif y > -8 and y <= 0:
		result = 2
	elif y > 0 and y <= 18:
		result = 1
	
	if result < 0:
		emit_signal("resource_destroyed")
	elif result == 0:
		emit_signal("resource_untouched")
	else:
		emit_signal("sucess", result)
	$AnimationPlayer.play("close_minigame")

func cancel():
	$AnimationPlayer.play("close_minigame")
	emit_signal("resource_untouched")

func _unhandled_input(event: InputEvent):
	if event.is_action("attack"):
		if Input.is_action_just_pressed("attack") and game_in_progress:
			on_clicked()
		get_tree().set_input_as_handled()

