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
			throw_torch()
			return
		
		if GameManager.can_fire_torch():
			add_new_torch()

func throw_torch():
	remove_child(torch)
	get_parent().get_parent().add_child(torch)
	torch.global_position = global_position
	torch.disconnect("finished", self, "throw_torch")
	torch = null

func add_new_torch():
	torch = TorchScene.instance()
	torch.connect("finished", self, "throw_torch")
	add_child(torch)
	GameManager.player_used_torch()
