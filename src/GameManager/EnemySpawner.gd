extends Node2D

var r = RandomNumberGenerator.new()
onready var root = get_parent().get_parent()

const Random = -1
const Skelly = preload("res://src/Enemy/Skelly/Skelly.tscn")
const Ghost = preload("res://src/Enemy/Ghost/Ghost.tscn")
const Mage = preload("res://src/Enemy/Mage/Mage.tscn")
var ENEMY_DICT := {
	Skelly: SKELLY_CHANCE,
	Ghost: GHOST_CHANCE,
	Mage: MAGE_CHANCE
}

const SKELLY_CHANCE = 1
const GHOST_CHANCE = 1
const MAGE_CHANCE = 1

const SPAWN_INTERVAL = Vector2(1.0, 2.5) # sec 
const SPAWN_DISTANCE = 150
const KILLS_TO_NAX_SPAWN := {
	0: 1,
	4: 2,
	10: 3,
	18: 4,
	26: 5
}
var required_enemy_count: int 
var enemy_chance_sum: int

var spawn_interval_start: int
var random_spawn_interval: float = -1

func _ready():
	r.randomize()
	for chance in ENEMY_DICT.values():
		enemy_chance_sum += chance

func _process(delta):
#	update_required_enemy_count()
	
	if GameManager.enemy_count < required_enemy_count:
		if can_spawn():
			spawn_random_enemy()

func update_required_enemy_count():
	for kills_required in KILLS_TO_NAX_SPAWN.keys():
		if GameManager.kill_count >= kills_required:
			required_enemy_count = KILLS_TO_NAX_SPAWN[kills_required]

func can_spawn():
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
	root.add_child(enemy)
	enemy.global_position = global_position + get_randow_place()
	GameManager.enemy_spawned()

func get_enemy() -> EnemyBase:
	var value = r.randf_range(0, enemy_chance_sum)
	var previous_chance := 0
	for enemy in ENEMY_DICT.keys():
		var enemy_chance = ENEMY_DICT[enemy]
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
