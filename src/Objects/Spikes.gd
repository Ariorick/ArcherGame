extends Area2D



func _on_Spikes_body_entered(body: Node2D):
	if body.is_in_group("enemies") or body.is_in_group("player"):
		$ActivateTimer.start()


func _on_ActivateTimer_timeout():
	$AnimatedSprite.speed_scale = 1
	$AnimatedSprite.play("activate")
	$DeactivateTimer.start()
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			body.take_damage(50)
		if body.is_in_group("player"):
			body.take_damage()


func _on_DeactivateTimer_timeout():
	$AnimatedSprite.speed_scale = 0.2
	$AnimatedSprite.play("activate", true)
