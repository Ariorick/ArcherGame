extends EnemyBase


func _ready():
	tag = "Skelly"
	set_hitpoints(1000)
	damage_treshold = 90
