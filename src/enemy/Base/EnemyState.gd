extends Node2D
class_name EnemyState
# Hold all information needed in Actions

export var type_name: String = "Base"
export var intimidation = 0
export var size = 1
export var max_health: float = 10.0

# current state
var is_dead: bool = false
var health: float



# updadted every frame from EnemyBase
var velocity: Vector2
var angle : float = Random.angle()

