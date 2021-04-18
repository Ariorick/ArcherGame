class_name Drawing

static func draw_circle(node: Node2D, radius: float, color: Color):
	var maxerror = 0.25
	if radius <= 0.0:
		return
	var maxpoints = 1024 # I think this is renderer limit

	var numpoints = ceil(PI / acos(1.0 - maxerror / radius))
	numpoints = clamp(numpoints, 3, maxpoints)

	var points = PoolVector2Array([])

	for i in numpoints + 1:
		var phi = i * PI * 2.0 / numpoints
		var v = Vector2(sin(phi), cos(phi))
		points.push_back(v * radius)
	node.draw_polyline(points, color)

static func draw_vectors_in_circle(
		node: Node2D, 
		scale: float,
		vectors: Array, 
		color: Color
	):
	var max_length := 1
	for v in vectors:
		max_length = max(v.length(), max_length)
	for v in vectors:
		node.draw_line(
			Vector2.ZERO, 
			v* scale, 
			color
			)
		draw_circle(node, max_length * scale, color)

static func draw_directions(
		node: Node2D, 
		directions: Array, 
		color: Color
	):
	var vectors := Array()
	for dir in directions:
		vectors.append(dir.get_vector())
	draw_vectors_in_circle(node, 0.3, vectors, color)

