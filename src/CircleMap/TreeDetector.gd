extends Area2D
class_name TreeDetector

var trees: Array

func _ready():
	$CollisionShape2D.set_shape($CollisionShape2D.get_shape().duplicate(true))

func get_trees():
	if trees == null or trees.empty():
		for node in get_overlapping_areas():
			if node is BaseTree:
				trees.append(node)
	return trees

func update_trees(current_radius: float):
	for tree in get_trees():
		tree.set_growth(get_scale_for_tree(tree.global_position, current_radius))


func get_scale_for_tree(pos: Vector2, radius) -> float:
	var distance = pos.distance_to(global_position)
	var scale = distance / radius
	
	var min_growth_distance := 1.0
	var max_growth_distance := 1.3
	var scale_between = (max_growth_distance * radius - distance) / (max_growth_distance - min_growth_distance) / radius
	
	if scale < min_growth_distance:
		return 0.0 
	elif scale > max_growth_distance:
		return 1.0
	else:
		return 1 - scale_between

func _on_TreeDetector_area_entered(area):
	if area is BaseTree and not trees.has(area):
		trees.append(area)
