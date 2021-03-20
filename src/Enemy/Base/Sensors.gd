extends Node2D
class_name Sensors

signal conditions_changed

var target: Node2D
var other_enemies: Array = []
var in_range: bool = false

# set this!
var parent_enemy: PhysicsBody2D

func _on_Vision_body_entered(body: PhysicsBody2D):
	if body.is_in_group("player"):
		target = body
		emit_signal("conditions_changed")
	if body.is_in_group("enemies") and body != parent_enemy:
		other_enemies.append(body)

func _on_Vision_body_exited(body: PhysicsBody2D):
	if body == target:
#		target = null
		emit_signal("conditions_changed")
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
