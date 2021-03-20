extends EnemyBase


func _ready():
	tag = "Ghost"
	set_hitpoints(10000)
	mass = 0.5
	linear_damp = 1.5
	damage_treshold = 50
