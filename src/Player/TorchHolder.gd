extends Node2D

const TorchScene = preload("res://src/CircleMap/Torch.tscn")

var torch: Torch

func _process(delta):
	if torch != null:
		if get_parent().linear_velocity.length() > 0:
			torch.position = get_parent().linear_velocity.normalized() * 5

func _unhandled_input(event):
	if Input.is_action_just_pressed("torch"):
		if torch != null:
			remove_child(torch)
			get_parent().get_parent().add_child(torch)
			torch.global_position = global_position
			torch = null
			return
		
		if GameManager.can_fire_torch():
			add_new_torch()


func add_new_torch():
	torch = TorchScene.instance()
	add_child(torch)
	GameManager.player_used_torch()
	
