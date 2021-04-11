extends Node2D

var DamageLabel = preload("res://src/UI/Damage/DamageLabel.tscn")

export var travel = Vector2(0, -5)
export var duration = 2
export var spread = PI/2

onready var parent = get_parent().get_parent().get_parent()

func show_value(value, crit=false):
	var damageLabel = DamageLabel.instance()
	parent.add_child(damageLabel)
	damageLabel.set_start_position(global_position)
	damageLabel.show_value(str(value), travel, duration, spread)
