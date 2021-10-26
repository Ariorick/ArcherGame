extends Node2D

var light_sources := Array()

func is_player_lit() -> bool:
	light_sources = ArrayUtils.filter_array_from_nulls(light_sources)
	return is_lit(GameManager.player_position)

func is_lit(v: Vector2) -> bool:
	for light in light_sources:
		if light.is_lit(v):
			return true
	return false

func add_light_source(light_source):
	light_sources.append(light_source)
