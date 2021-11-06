extends Node2D


#var first_pos = Vector2(192, 104)
#var second_pos = Vector2(192, 216)

var first_pos = null
var second_pos = null

var path: PoolVector2Array

onready var navigation = get_parent().get_node("Navigation2D")

func _process(delta):
	if not Input.is_action_just_pressed("attack"):
		return
	var mouse_pos = get_global_mouse_position()
	if first_pos == null:
		first_pos = mouse_pos
		return
	if second_pos == null:
		second_pos = mouse_pos
	
	if first_pos != null and second_pos != null:
		path = navigation.get_simple_path(
			Math.round_v(navigation.get_closest_point(first_pos)), 
			Math.round_v(navigation.get_closest_point(second_pos))
			)
		print(path)
		first_pos = null
		second_pos = null
		update()

func _draw():
	if path.size() < 1:
		draw_circle(Vector2(100, 100), 10, Color.red)
		return
	draw_circle(path[0], 2, Color.cyan)
	draw_polyline(path, Color.red, 1)
	draw_circle(path[path.size() - 1], 3, Color.red)
	for i in path.size() - 1:
		draw_circle(path[i], 2, Color.red)



