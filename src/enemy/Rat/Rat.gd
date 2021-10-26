extends EnemyBase
class_name Rat

func _ready():
	tag = "Rat"
	set_hitpoints(20)
	damage_treshold = 3
