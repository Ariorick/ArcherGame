extends Node2D
class_name Minigame

const STRIPE_MAX = 47
const STRIPE_TIME = 0.5

signal sucess(item_count)
signal resource_destroyed()
signal resource_untouched()

var item_id: String
var resource_texture: Texture

var game_in_progress
var closing

onready var stripe = $StripeContainer/Stripe

func _ready():
	$AnimationPlayer.play("init_minigame")
	pass

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "move_stripe" or anim_name == "move_stripe_reverse":
		$StripeContainer/Stripe.visible = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "init_minigame":
		if Random.boolean():
			$AnimationPlayer.play("move_stripe", -1, Random.f_range(0.8, 1.2))
		else:
			$AnimationPlayer.play("move_stripe_reverse", -1, Random.f_range(0.8, 1.2))
		game_in_progress = true
	if anim_name == "close_minigame" or anim_name == "finish_minigame":
		queue_free()


func on_clicked():
	$AnimationPlayer.stop()
	var y = stripe.position.y
	var result = 0
	if y < 12:
		result = -1
	elif y >= 12 and y <= 17:
		result = 3
	elif y > 17 and y <= 25:
		result = 2
	elif y > 25 and y <= 43:
		result = 1
	
	if result < 0:
		emit_signal("resource_destroyed")
	elif result == 0:
		emit_signal("resource_untouched")
	else:
		emit_signal("sucess", result)
	$AnimationPlayer.play("finish_minigame")
	closing = true

func cancel():
	$AnimationPlayer.play("close_minigame")
	emit_signal("resource_untouched")


func _unhandled_input(event: InputEvent):
	if event.is_action("attack"):
		if Input.is_action_just_pressed("attack") and game_in_progress and not closing:
			on_clicked()
		if not closing:
			get_tree().set_input_as_handled()

