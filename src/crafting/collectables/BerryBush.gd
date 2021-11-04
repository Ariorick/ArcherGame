extends Collectable
class_name BerryBush

#override
func on_collected():
	$Visuals/Sprite.visible = false
	$Visuals/SpriteNoBerries.visible = true
