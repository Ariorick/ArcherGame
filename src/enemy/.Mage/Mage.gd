extends EnemyBase
class_name Mage

func _ready():
	tag = "Mage"
	set_hitpoints(30)
	mass = 1
	linear_damp = 3.0
	damage_treshold = 5
