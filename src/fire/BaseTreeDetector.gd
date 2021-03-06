extends Area2D
class_name BaseTreeDetector

var trees: Array

func _ready():
	$CollisionShape2D.set_shape($CollisionShape2D.get_shape().duplicate(true))

func update_tree(tree):
	pass

func _on_TreeDetector_area_entered(area):
	if area is BaseTree and not trees.has(area):
		trees.append(area)
		update_tree(area)

func _on_TreeDetector_area_exited(area):
	if area is BaseTree and not trees.has(area):
		trees.erase(area)

func get_trees():
	if trees == null or trees.empty():
		for node in get_overlapping_areas():
			if node is BaseTree:
				trees.append(node)
	return trees

func drop_trees(): 
	trees = Array()

func set_growth_to_tree(tree, growth):
	tree.set_growth(growth, self)
