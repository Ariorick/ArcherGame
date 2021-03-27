extends EnemyBase
class_name Skelly

func _ready():
	tag = "Skelly"
	set_hitpoints(700)
	damage_treshold = 90
