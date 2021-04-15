extends EnemyBase
class_name Skelly

func _ready():
	tag = "Skelly"
	set_hitpoints(50)
	damage_treshold = 90
