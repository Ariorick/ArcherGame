extends Node2D

const SPAWN_DISTANCE = 400
const Skelly = preload("res://src/Enemy/Skelly/Skelly.tscn")
const Ghost = preload("res://src/Enemy/Ghost/Ghost.tscn")

var r = RandomNumberGenerator.new()
onready var root = get_parent().get_parent()

func _ready():
	r.randomize()

func _on_Timer_timeout():
	var enemy = get_enemy()
	root.add_child(enemy)
	enemy.global_position = global_position + get_randow_place()

func get_enemy() -> EnemyBase:
	var value = r.randf_range(0, 1)
	var enemy: EnemyBase
	if value < 1:
		enemy = Skelly.instance()
	else: 
		enemy = Ghost.instance()
	return enemy

func get_randow_place() -> Vector2:
	return Vector2(0, SPAWN_DISTANCE).rotated(random_angle())

func random_angle() -> float:
	return r.randf_range(-PI, PI)
