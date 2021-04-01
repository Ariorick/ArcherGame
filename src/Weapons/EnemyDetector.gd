extends Area2D

var enemies := Array()

func _on_EnemyDetector_body_entered(body: PhysicsBody2D):
	if body.is_in_group("enemy_hitbox"):
		enemies.append(body)


func _on_EnemyDetector_body_exited(body):
	if body.is_in_group("enemy_hitbox"):
		enemies.erase(body)
