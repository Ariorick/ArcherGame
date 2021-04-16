extends Node
class_name ArrayUtils

static func filter_array_from_nulls(array: Array) -> Array:
	var new_array = Array()
	for item in array:
		if is_instance_valid(item):
			new_array.append(item)
	return new_array
