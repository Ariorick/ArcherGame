extends Navigation2D

const WATER_ID = 2

onready var tilemap: TileMap = get_parent().get_node(NodePath("Background"))
onready var cell_size = tilemap.cell_size
onready var space: Physics2DDirectSpaceState = get_world_2d().direct_space_state

var cells := Array()

func _ready():

	var water_cells := tilemap.get_used_cells_by_id(WATER_ID)
	for cell in tilemap.get_used_cells():
		if water_cells.has(cell):
			continue
		if is_obstructed(cell):
			continue
		cells.append(cell)
	
	# 0 - 260 stone
	# 1 - 1600 dirt
	# 2 - 1200 this is water
	# 3 - 1400 grass
	update()

func is_obstructed(cell: Vector2) -> bool:
	var k = 0.1
	var check_points = [
		cell + Vector2(k, k),
		cell + Vector2(0, 1) + Vector2(k, -k),
		cell + Vector2(1, 1) + Vector2(-k, -k),
		cell + Vector2(1, 0) + Vector2(-k, k)
	]
	for point in check_points:
		if space.intersect_point(point * cell_size, 1):
			return true
	return false

func _draw():
	for cell in cells:
		var draw_rect = Rect2(cell * cell_size, Vector2.ONE * cell_size)
		draw_rect(draw_rect, Color(1, 1, 0, 0.5), true, 1)

func add_navpoly(cell: Vector2):
	var polygon = NavigationPolygon.new()
	var outline = PoolVector2Array(
		[Vector2(0, 0), 
		Vector2(0, cell_size.y), 
		cell_size, 
		Vector2(cell_size.x, 0)]
		)
	polygon.add_outline(outline)
	polygon.make_polygons_from_outlines()

	navpoly_add(polygon, Transform2D(0, cell * cell_size))
	
	
