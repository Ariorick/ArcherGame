extends Node2D
class_name Sensors

signal conditions_changed
signal alarmed_by

var actors: Array
var actors_in_range: Array
var resources: Array

# set this!
var parent_enemy: PhysicsBody2D

func body_matters(body: PhysicsBody2D) -> bool:
	if not is_instance_valid(body):
		return false
	return body.is_in_group("player") or (body.is_in_group("enemies") and body != parent_enemy)

func get_directions() -> Array:
	return $CircularRaycasts.get_directions()

func set_raycast_exceptions(exceptions: Array):
	 $CircularRaycasts.set_exceptions(exceptions)

func _on_Vision_body_entered(body: PhysicsBody2D):
	if body_matters(body):
		body.connect("on_enemy_alarmed", self, "target_found")
		actors.append(body)

func _on_Vision_body_exited(body: PhysicsBody2D):
	if actors.has(body):
		actors.erase(body)
		emit_signal("conditions_changed")

func _on_AttackRadius_body_entered(body):
	if body_matters(body):
		actors_in_range.append(body)
		emit_signal("conditions_changed")

func _on_AttackRadius_body_exited(body):
	if actors_in_range.has(body):
		emit_signal("conditions_changed")

func target_found(body):
#	if target != null:
#		return
#	target = body
#	emit_signal("alarmed_by", target)
#	emit_signal("conditions_changed")
	pass

