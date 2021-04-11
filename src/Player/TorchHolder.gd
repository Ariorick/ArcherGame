extends Node2D

const TorchScene = preload("res://src/CircleMap/Torch.tscn")

var torch: Torch

func _unhandled_input(event):
	if Input.is_action_just_pressed("torch"):
		if torch != null:
			remove_child(torch)
			get_parent().get_parent().add_child(torch)
			torch.global_position = global_position
		
		if GameManager.can_fire_torch():
			add_new_torch()


func add_new_torch():
	torch = TorchScene.instance()
	add_child(torch)
	GameManager.player_used_torch()
	
