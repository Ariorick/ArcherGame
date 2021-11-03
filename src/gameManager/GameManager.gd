extends Node

const MAX_HEALTH := 10
const MAX_ARROW_COUNT := 5
const PLAYER_START_POSITION = Vector2(120, 56)

signal on_player_death


var health := MAX_HEALTH
var is_dead = false
var arrow_count := MAX_ARROW_COUNT
var is_holding_torch := false

var player
var player_position: Vector2

func player_died():
	is_dead = true
	emit_signal("on_player_death")

func reset_player():
	is_dead = false
	if player != null:
		player.position = PLAYER_START_POSITION

func player_used_arrow():
	arrow_count -= 1

func player_collected_arrow():
	arrow_count += 1

#    TODO: this is a trash class, can_shoot and can dash should be somewhere near player
func can_shoot():
	return arrow_count > 0 and not is_holding_torch

func can_dash():
	return not is_holding_torch 

func player_picked_torch():
	is_holding_torch = true

func player_dropped_torch():
	is_holding_torch = false

func player_take_damage():
	health -= 1
	print("Player health is ", health, "/", MAX_HEALTH)
	emit_signal("player_health_changed")

func get_health_percent():
	return 1.0 * health / MAX_HEALTH

func _input(event):
	if is_dead:
		get_tree().set_input_as_handled()
