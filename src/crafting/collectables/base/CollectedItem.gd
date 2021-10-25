extends Node2D
class_name CollectedItem

const CollectedItemAnimation = preload("res://src/crafting/collectables/base/CollectedItemAnimation.tscn")

const SPREAD = 4 #px

var amount = 1
var item_id

var i: int = 1

func _on_Timer_timeout():
	if i == amount:
		$Timer.stop()
	i += 1
	var item_animation = CollectedItemAnimation.instance()
	var item = Item.new(item_id)
	item_animation.texture = load(item.icon)
	add_child(item_animation, 0)
	item_animation.position = Vector2(-(SPREAD * amount)/2 + SPREAD * i + 5, 0)
