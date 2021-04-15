extends Area2D
class_name SwordArea


func _physics_process(delta):
	var direction = PlayerInput.get_mouse_direction(self)
	rotation = direction.angle()
	
	if Input.is_action_just_pressed("attack"):
		$SlashAnimationPlayer.play("Slash")
		get_parent().apply_impulse(Vector2.ZERO, direction * 70)



func _on_SwordArea_body_entered(body):
	if body.is_in_group("enemy_hitbox"):
		var enemy = body.get_parent().get_parent()
		var direction = (enemy.global_position - GameManager.player_position).normalized()
		enemy.take_directional_damage(10, direction)
