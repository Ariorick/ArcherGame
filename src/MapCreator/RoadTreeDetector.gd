extends Area2D
class_name RoadTreeDetector

var trees: Array

func drop_trees(): 
	print(trees.size())
	trees = Array()

func get_trees():
	if trees == null or trees.empty():
		for node in get_overlapping_areas():
			if node is BaseTree:
				trees.append(node)
	return trees

func update_trees(current_width: float, current_length: float):
	for tree in get_trees():
		tree.set_growth(get_scale_for_tree(tree.global_position, current_width, current_length))

func get_scale_for_tree(pos: Vector2, width: float, length: float) -> float:
	var to_pos = pos - global_position
	var to_pos_rotated = to_pos.rotated(-get_parent().rotation)
	
	var distance = abs(to_pos_rotated.x)
	
	var scale = distance / width
	if scale > 1.0:
		print("AAAA")
		print("dist " + str(distance) + " " + str(width))
	
	var min_growth_distance := 1.0
	var max_growth_distance := 1.1
	var scale_between = 0.5
	
	if scale < min_growth_distance:
		return 0.0 
	elif scale > max_growth_distance:
		return 1.0
	else:
		return 0.5


func _on_TreeDetector_area_entered(area):
	if area is BaseTree and not trees.has(area):
		trees.append(area)
