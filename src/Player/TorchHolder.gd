extends Node2D

const TorchScene = preload("res://src/Fire/Torch.tscn")
const TORCH_MOVEMENT_CIRCLE_RADIUS = 8

var torch: Torch
var can_pickup_torch_ref = funcref(self, "can_pickup_torch")

func _process(delta):
	if torch != null:
		if get_parent().linear_velocity.length() > 0:
			torch.position = get_parent().linear_velocity.normalized() * TORCH_MOVEMENT_CIRCLE_RADIUS

func _unhandled_input(event):
	if Input.is_action_just_pressed("throw_torch"):
		if torch != null:
			throw_torch()

func get_or_refill_torch():
	if torch == null:
		add_new_torch()
	else:
		torch.reset()

# Move animation of picking up torch here, so it would count as "picked" when it starts
func get_torch_back(torch: Torch):
	self.torch = torch
	torch.get_parent().remove_child(torch)
	add_child(torch)
	torch.connect("finished", self, "throw_torch")

func on_player_got_hit(direction: Vector2 = Vector2.ZERO):
	if torch != null:
		throw_torch(direction)

func throw_torch(direction: Vector2 = Vector2.ZERO):
	remove_child(torch)
	get_parent().get_parent().add_child(torch)
	torch.global_position = global_position
	torch.disconnect("finished", self, "throw_torch")
	torch.on_thrown_away(direction)
	torch = null
	GameManager.player_dropped_torch()

func add_new_torch():
	torch = TorchScene.instance()
	torch.can_pickup_ref = can_pickup_torch_ref
	torch.connect("finished", self, "throw_torch")
	torch.connect("collected", self, "get_torch_back")
	add_child(torch)
	GameManager.player_picked_torch()

func can_pickup_torch() -> bool:
	return torch == null
