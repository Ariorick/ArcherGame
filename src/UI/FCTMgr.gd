extends Node2D

var FCT = preload("res://src/UI/FCT.tscn")

export var travel = Vector2(0, -60)
export var duration = 2
export var spread = PI/2

func show_value(value, crit=false):
	var fct: FCT = FCT.instance()
	add_child(fct)
	fct.show_value(str(value), travel, duration, spread, crit)
