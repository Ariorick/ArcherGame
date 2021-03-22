extends EnemyBase
class_name Skelly

func _ready():
	tag = "Skelly"
	set_hitpoints(1000)
	damage_treshold = 90
