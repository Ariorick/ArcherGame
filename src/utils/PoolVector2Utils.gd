extends Node
class_name PoolVector2Utils

static func add_vector_to_path(path: PoolVector2Array, vector: Vector2) -> PoolVector2Array:
	var result : = PoolVector2Array()
	for point in path:
		result.append(point + vector)
	return result

static func length(path: PoolVector2Array) -> float:
	var length = 0.0
	for i in path.size() - 1:
		length += path[i].distance_to(path[i + 1])
	return length
