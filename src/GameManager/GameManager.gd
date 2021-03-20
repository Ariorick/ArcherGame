extends Node

signal player_health_changed
signal arrow_count_changed

const MAX_HEALTH := 10
var health := MAX_HEALTH

const MAX_ARROW_COUNT := 10
var arrow_count := MAX_ARROW_COUNT

func player_used_arrow():
	arrow_count -= 1
	emit_signal("arrow_count_changed")

func player_collected_arrow():
	arrow_count += 1
	emit_signal("arrow_count_changed")

func can_shoot():
	return arrow_count > 0

func player_take_damage():
	health -= 1
	print("player got hit", "health is ", health, "/", MAX_HEALTH)
	emit_signal("player_health_changed")

func get_health_percent():
	return 1.0 * health / MAX_HEALTH
