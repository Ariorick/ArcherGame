extends EnemyBase


func _ready():
	tag = "Skelly"
	set_hitpoints(10000)
	damage_treshold = 90
