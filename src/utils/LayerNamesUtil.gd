extends Node
# LayerNamesUtil

var layers := Array()

func _ready():
	for i in range(1, 21):
		layers.insert(i, ProjectSettings.get_setting("layer_names/2d_physics/layer_" + str(i)))
	
	for layer in layers:
		print(layer)

func get_collision_mask(names: Array) -> int:
	var mask = 0
	for name in names:
		mask += 2 * layers.find(name)
	return mask

