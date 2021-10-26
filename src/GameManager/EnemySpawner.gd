extends Node2D

signal level_finished
signal enemy_died

var r = RandomNumberGenerator.new()
onready var root = get_parent().get_parent()

const Skelly = preload("res://src/enemy/Skelly/Skelly.tscn")
const Ghost = preload("res://src/enemy/Ghost/Ghost.tscn")
const Mage = preload("res://src/enemy/Mage/Mage.tscn")
var ENEMY_SCENES := {
	SpawnerProgram.SKELLY: Skelly,
	SpawnerProgram.GHOST: Ghost,
	SpawnerProgram.MAGE: Mage
}

const SPAWN_INTERVAL = Vector2(0.5, 1) # sec 
const SPAWN_OFFSET = 50

var spawn_radius: float
var chance_dict: Dictionary
var spawn_dict: Dictionary

var required_enemy_count: int 
var enemy_chance_sum: int

var spawn_interval_start: int
var random_spawn_interval: float = -1

var killed_count = 0
var spawned_count = 0
var current_enemy_count = 0

func _ready():
	r.randomize()
	set_process(false)

func _process(delta):
	update_required_enemy_count()
	
	if killed_count == get_max_enemies():
		set_process(false)
		print("LEVEL_FINISHED")
		emit_signal("level_finished")
		return
	
	if current_enemy_count < required_enemy_count:
		if can_spawn():
			spawn_random_enemy()

func update_required_enemy_count():
	for kills_required in spawn_dict.keys():
		if killed_count < kills_required:
			required_enemy_count = spawn_dict[kills_required]
			return

func can_spawn():
	if spawned_count == get_max_enemies():
		return false
	
	if random_spawn_interval < 0:
		spawn_interval_start = OS.get_ticks_msec()
		random_spawn_interval = r.randf_range(SPAWN_INTERVAL.x, SPAWN_INTERVAL.y)
	var elapced = (OS.get_ticks_msec() - spawn_interval_start) / 1000.0
	var can_spawn = elapced > random_spawn_interval
	if can_spawn:
		random_spawn_interval = -1
	return can_spawn

func spawn_random_enemy():
	var enemy = get_enemy()
	enemy.connect("on_enemy_death", self, "on_enemy_death")
	root.add_child(enemy)
	enemy.global_position = global_position + get_randow_place()
	on_enemy_spawn()

func get_enemy() -> EnemyBase:
	var value = r.randf_range(0, enemy_chance_sum)
	var previous_chance := 0
	for enemy_tag in chance_dict.keys():
		var enemy_chance = chance_dict[enemy_tag]
		var chance = value - previous_chance
		if chance < enemy_chance:
			return ENEMY_SCENES[enemy_tag].instance()
		previous_chance += enemy_chance
#	Something's broken if null is returned
	return null

func get_max_enemies():
	var keys = spawn_dict.keys()
	return keys[keys.size() - 1]

func on_enemy_death():
	killed_count += 1
	current_enemy_count -= 1
	emit_signal("enemy_died")

func on_enemy_spawn():
	spawned_count += 1
	current_enemy_count += 1

func set_program(value: SpawnerProgram):
	if value == null:
		return
	chance_dict = value.chance_dict
	spawn_dict = value.spawn_count
	for chance in chance_dict.values():
		enemy_chance_sum += chance

func get_randow_place() -> Vector2:
	return Vector2(0, spawn_radius + SPAWN_OFFSET).rotated(random_angle())

func random_angle() -> float:
	return r.randf_range(-PI, PI)
