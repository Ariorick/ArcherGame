tool
extends Node2D
class_name FireEffect

export var smoke: bool = true setget set_smoke, get_smoke
export var fire: bool = true setget set_fire, get_fire

func add_sparks():
	$ResetParticles.emitting = true

func set_smoke(value: bool):
	$SmokeParticles.emitting = value

func get_smoke() -> bool:
	return $SmokeParticles.emitting

func set_fire(value: bool):
	$FireParticles.emitting = value

func get_fire() -> bool:
	return $FireParticles.emitting
