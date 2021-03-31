extends Node2D

var parent: Node2D
var map_scale: float

func _process(delta):
	position = GameManager.player_position + Vector2(120, 30)
	update()

# Array of Circles
func draw_map(parent: Node2D):
	self.parent = parent
	var max_value = 1000
	for child in parent.get_children():
		if child is Circle:
			max_value = min(child.position.y, max_value)
	if max_value == 0:
		max_value = 1000
	map_scale = -50.0 / max_value 
	print(map_scale)

func _draw():
	for child in parent.get_children():
		if child is Circle:
			draw_circle(
				child.position * map_scale, 
				child.radius * map_scale, 
				color_with_alpha(Color.aliceblue, 0.3))
			draw_circle(
				child.position * map_scale, 
				child.current_radius * map_scale, 
				color_with_alpha(Color.blue, 0.3))
				
		if child is Road:
			draw_set_transform(
				(child.position) * map_scale,
				 child.rotation, 
				Vector2(1, 1)
			)
			draw_rect(
				Rect2(
					Vector2.ZERO - Vector2(child.width, child.length) * map_scale,
					Vector2(child.width * 2, child.length * 2) * map_scale
				),
				color_with_alpha(Color.aliceblue, 0.3), 
				true
			)
			draw_rect(
				Rect2(
					Vector2.ZERO - Vector2(child.current_width, child.length) * map_scale,
					Vector2(child.current_width * 2, child.length * 2) * map_scale
				),
				color_with_alpha(Color.blue, 0.3), 
				true
			)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2(1, 1))

func color_with_alpha(color: Color, alpha: float) -> Color:
	color.a = alpha
	return color 
