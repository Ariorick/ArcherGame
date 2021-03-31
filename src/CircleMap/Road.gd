extends Node2D
class_name Road

var length: float
var width: float
var current_width: float = 0.0

func _ready():
	$TreeDetector/CollisionShape2D.shape.extents.y = length
	$TreeDetector/CollisionShape2D.shape.extents.x = width
	pass

func _process(delta):
	update_trees()
	update()

func _draw():
	draw_rect(Rect2(0 - current_width, 0 - length, current_width * 2, length * 2), Color.white, false)
	pass

func update_trees():
	if current_width != 0:
		$TreeDetector.update_trees(current_width)
