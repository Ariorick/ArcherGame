extends Node2D

const Skelly = preload("res://src/Enemy/Skelly/Skelly.tscn")
const Ghost = preload("res://src/Enemy/Ghost/Ghost.tscn")
const Mage = preload("res://src/Enemy/Mage/Mage.tscn")
const SKELLY_CHANCE = 0
const GHOST_CHANCE = 0
const MAGE_CHANCE = 5

const SPAWN_DISTANCE = 200
const SPAWN_INTERVAL = 1

var enemy_dict := {
	Skelly: SKELLY_CHANCE,
	Ghost: GHOST_CHANCE,
	Mage: MAGE_CHANCE
}
var enemy_chance_sum: int
var r = RandomNumberGenerator.new()
onready var root = get_parent().get_parent()

func _ready():
	r.randomize()
	$Timer.wait_time = SPAWN_INTERVAL
	for chance in enemy_dict.values():
		enemy_chance_sum += chance

func _on_Timer_timeout():
	var enemy = get_enemy()
	root.add_child(enemy)
	enemy.global_position = global_position + get_randow_place()

func get_enemy() -> EnemyBase:
	var value = r.randf_range(0, enemy_chance_sum)
	var previous_chance := 0
	for enemy in enemy_dict.keys():
		var enemy_chance = enemy_dict[enemy]
		var chance = value - previous_chance
		if chance < enemy_chance:
			return enemy.instance()
		previous_chance += enemy_chance
#	Something's broken if null is returned
	return null

func get_randow_place() -> Vector2:
	return Vector2(0, SPAWN_DISTANCE).rotated(random_angle())

func random_angle() -> float:
	return r.randf_range(-PI, PI)
