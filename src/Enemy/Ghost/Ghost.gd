extends EnemyBase
class_name Ghost

func _ready():
	tag = "Ghost"
	set_hitpoints(20)
	mass = 1.0
	linear_damp = 1.5
	damage_treshold = 50
