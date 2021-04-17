extends Node2D
class_name ParticlesBundle

export var emitting: bool setget set_emitting, is_emitting

func is_emitting() -> bool:
	if not get_children().empty():
		return get_children()[0].emitting
	else: 
		return false

func set_emitting(emit: bool):
	for kid in get_children():
		kid.emitting = emit
