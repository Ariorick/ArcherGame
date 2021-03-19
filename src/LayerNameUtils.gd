

static func binary(bools: Array) -> int:
	var result = 0
	for i in bools.size():
		if bools[i]:
			result += pow(2, i)
	return result

