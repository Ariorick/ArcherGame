extends CenterContainer
class_name DeathScreen

func _ready():
	modulate = Color.transparent
	GameManager.connect("on_player_death", self, "on_player_death")

func on_player_death():
	$AnimationPlayer.play("death_screen")
	Saver.load_game()


func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.
