extends Node
class_name PathFinder


static func find_closest_target(nodes: Array, global_position: Vector2, intention_vector : Vector2 = Vector2()) -> Node2D:
	var closest_node : Node2D = null
	var shortest_path_length : = Utils.MAX_FLOAT
	for node in nodes:
		var path_length = global_position.distance_to(node.global_position + intention_vector)
		if (path_length == 0.0):
			continue
		if (path_length < shortest_path_length):
			shortest_path_length = path_length
			closest_node = node
	return closest_node

# at least two points in array
static func caclulate_path_length(path: PoolVector2Array) -> float:
	var length = 0.0
	for i in range(path.size() - 1):
		length += path[i].distance_to(path[i + 1])
	return length
