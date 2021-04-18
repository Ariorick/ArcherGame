extends Node2D
class_name Sensors

signal conditions_changed
signal alarmed_by

var target: Node2D
var other_enemies: Array = []
var in_range: bool = false

# set this!
var parent_enemy: PhysicsBody2D

func get_directions() -> Array:
	return $CircularRaycasts.get_directions()

func set_raycast_exceptions(exceptions: Array):
	 $CircularRaycasts.set_exceptions(exceptions)

func _on_Vision_body_entered(body: PhysicsBody2D):
	if body.is_in_group("player"):
		target_found(body)
	if body.is_in_group("enemies") and body != parent_enemy:
		body.connect("on_enemy_alarmed", self, "target_found")
		other_enemies.append(body)

func _on_Vision_body_exited(body: PhysicsBody2D):
#	if body == target:
#		target = null
#		emit_signal("conditions_changed")
	if body.is_in_group("enemies"):
		other_enemies.erase(body)

func _on_AttackRadius_body_entered(body):
	if body.is_in_group("player"):
		in_range = true
		emit_signal("conditions_changed")

func _on_AttackRadius_body_exited(body):
	if body.is_in_group("player"):
		in_range = false
		emit_signal("conditions_changed")

func target_found(body):
	if target != null:
		return
	target = body
	emit_signal("alarmed_by", target)
	emit_signal("conditions_changed")

