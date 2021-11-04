extends Node
class_name ArrayUtils

static func filter_array_from_nulls(array: Array) -> Array:
	var new_array = Array()
	for item in array:
		if is_instance_valid(item):
			new_array.append(item)
	return new_array


static func map(array: Array, map_function: FuncRef) -> Array:
	var output := []
	for value in array:
		output.append(map_function.call_func(value))
	return output

static func map_var(array: Array, var_name: String) -> Array:
	var output := []
	for value in array:
		output.append(value.get(var_name))
	return output

static func filter(array: Array, filter_function: FuncRef) -> Array:
	var output := []
	for value in array:
		if filter_function.call_func(value):
			output.append(value)
	return output
