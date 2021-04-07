extends BaseTreeDetector
class_name CircleTreeDetector

func update_trees(current_radius: float):
	for tree in get_trees():
		set_growth_to_tree(tree, get_scale_for_tree(tree.global_position, current_radius))


func get_scale_for_tree(pos: Vector2, radius) -> float:
	var distance = pos.distance_to(global_position)
	var scale = distance / radius
	
	var min_growth_distance := 1.0
	var max_growth_distance := 1.2
	radius = max(0.01, radius)
	var scale_between = (max_growth_distance * radius - distance) / (max_growth_distance - min_growth_distance) / radius
	
	if scale < min_growth_distance:
		return 0.0 
	elif scale > max_growth_distance:
		return 1.0
	else:
		return 1 - scale_between
