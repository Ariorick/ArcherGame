extends BaseTreeDetector
class_name RoadTreeDetector


func update_trees(current_width: float):
	for tree in get_trees():
		set_growth_to_tree(tree, get_scale_for_tree(tree.global_position, current_width))

func get_scale_for_tree(pos: Vector2, width: float) -> float:
	var to_pos = pos - global_position
	var to_pos_rotated = to_pos.rotated(-get_parent().rotation)
	
	var distance = abs(to_pos_rotated.x)
	
	var scale = distance / width
	
	var min_growth_distance := 1.0
	var max_growth_distance := 1.1
	var scale_between = (scale - min_growth_distance) / (max_growth_distance - min_growth_distance)
	
	if scale <= min_growth_distance:
		return 0.0 
	elif scale >= max_growth_distance:
		return 1.0
	else:
		return scale_between
