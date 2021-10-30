extends BaseTreeDetector
class_name CircleTreeDetector

var current_radius: float = 0.0

func update_trees(radius: float):
	if radius == current_radius:
		return
	current_radius = radius
	for tree in get_trees():
		if is_instance_valid(tree):
			update_tree(tree)
		else:
			trees.erase(tree)

func update_tree(tree):
	set_growth_to_tree(tree, get_scale_for_tree(tree.global_position, current_radius))

func set_shape_radius(radius: float):
	$CollisionShape2D.shape.radius = radius

func get_scale_for_tree(pos: Vector2, radius) -> float:
	var distance = pos.distance_to(global_position)
	radius = max(0.01, radius)
	
	# SIMPLE
	return float(distance >= radius)
	
	# OLD
#	var scale = distance / radius
#
#	var min_growth_distance := 1.0
#	var max_growth_distance := 1.2
#	var scale_between = (max_growth_distance * radius - distance) / (max_growth_distance - min_growth_distance) / radius
#
#	if scale < min_growth_distance:
#		return 0.0 
#	elif scale > max_growth_distance:
#		return 1.0
#	else:
#		return 1 - scale_between
	
