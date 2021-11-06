extends Navigation2D

const WATER_ID = 2
const POLYGON_POINTS := PoolVector2Array([
			Vector2(0, 0),
			Vector2(0, 0.5),
			Vector2(0, 1),
			Vector2(0.5, 1),
			Vector2(1, 1),
			Vector2(1, 0.5),
			Vector2(1, 0),
			Vector2(0.5, 0)
			])

onready var tilemap: TileMap = get_parent().get_node(NodePath("Background"))
onready var cell_size = tilemap.cell_size
onready var space: Physics2DDirectSpaceState = get_world_2d().direct_space_state

var polygons := Array()

func _ready():
	var mask: int = LayerNamesUtil.get_collision_mask(["walls", "unwalkable"])
	
	var water_cells := tilemap.get_used_cells_by_id(WATER_ID)
	for cell in tilemap.get_used_cells():
#		if water_cells.has(cell):
#			continue
#		add_cell(cell, mask)
#		if is_obstructed(cell, mask):
#			continue
#		add_navpoly(cell)
		add_cell(cell, mask)
	
#	update()


func add_cell(cell: Vector2, mask: int):
	var outline: PoolVector2Array
	var transformed_outline: PoolVector2Array
	for polygon_point in POLYGON_POINTS:
		var point = (cell + polygon_point) * cell_size 
		if not is_point_obstructed_with_lookaround(point, mask):
			outline.append(polygon_point * cell_size)
			transformed_outline.append(point)
	if outline.size() < 3:
		return
	
	polygons.append(transformed_outline)
	
	var polygon = NavigationPolygon.new()
	polygon.add_outline(outline)
	polygon.make_polygons_from_outlines()
	navpoly_add(polygon, Transform2D(0, cell * cell_size))



func is_point_obstructed(point, mask) -> bool:
	return not space.intersect_point(point, 1, [], mask).empty()

func is_point_obstructed_with_lookaround(point: Vector2, mask) -> bool:
	var k = 2
	var check_points = [
		Vector2(0,0),
		Vector2(k, k),
		Vector2(k, -k),
		Vector2(-k, -k),
		Vector2(-k, k)
	]
	for v in check_points:
		if is_point_obstructed(point + v, mask):
			return true
	return false

func _draw():
	for polygon in polygons:
		for point in polygon:
			draw_circle(point, 1, Color.black)
		
		var colors := PoolColorArray()
		colors.append(Color(1, 1, 0, 0.3))
		draw_polygon(polygon, colors)
	pass

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
	
	
