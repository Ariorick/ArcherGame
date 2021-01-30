class_name Mover

var _path : = PoolVector2Array() setget set_path

func move_along_path(current_position: Vector2, distance : float) -> Vector2:
	var last_point : = current_position
	for index in range(_path.size()):
		var distance_to_next = last_point.distance_to(_path[0])
		# if we won't reach the point on this frame
		if distance <= distance_to_next and distance > 0.0:
			last_point = last_point.linear_interpolate(_path[0], distance / distance_to_next)
			break
		# if we can finish move
		elif _path.size() == 1 and distance >= distance_to_next:
			last_point = _path[0]
			_path.remove(0)
			break

		distance -= distance_to_next
		last_point = _path[0]
		_path.remove(0)
	return last_point

func cancel_move():
	_path = PoolVector2Array()

func set_path(value : PoolVector2Array):
	_path = value
	if _path.size() != 0:
		_path.remove(0)

func path_empty() -> bool:
	return _path.empty()
