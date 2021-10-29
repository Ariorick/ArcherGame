extends Node2D

var light_sources := Array()
var get_tree_level: FuncRef # Vector2 -> int

func is_player_lit() -> bool:
	if get_tree_level != null and get_tree_level.call_func(GameManager.player_position) > 1:
		return false
	light_sources = ArrayUtils.filter_array_from_nulls(light_sources)
	return is_lit(GameManager.player_position)

func is_lit(v: Vector2) -> bool:
	for light in light_sources:
		if light.is_lit(v):
			return true
	return false

func add_light_source(light_source):
	light_sources.append(light_source)
