extends Node2D
class_name CollectedItemAnimation

var texture: Texture

func _ready():
	var sprite = $Sprite
	$Sprite.texture = texture
	$AnimationPlayer.play("show_item")
