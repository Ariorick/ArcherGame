extends Node
class_name PoolVector2Utils

static func add_vector_to_path(path: PoolVector2Array, vector: Vector2) -> PoolVector2Array:
	var result : = PoolVector2Array()
	for point in path:
		result.append(point + vector)
	return result
