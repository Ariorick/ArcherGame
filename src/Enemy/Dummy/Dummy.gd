extends EnemyBase
class_name Dummy

func _ready():
	tag = "Dummy"
	set_hitpoints(10000)
	mass = 3
	linear_damp = 3
	damage_treshold = 50
