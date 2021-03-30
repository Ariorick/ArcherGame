extends Node2D
class_name Road

var length: float
var width: float
export var current_width: float = 10
var current_length: float = 10

func _ready():
#	$AnimationPlayer.play("TestRoadTrees")
	pass

func _process(delta):
	update_trees()
	update()

func _draw():
#	draw_rect(Rect2(0 - current_width, 0 - current_length, current_width * 2, current_length * 2), Color.white, false)
	pass

func set_length(length: float):
	self.length = length
	$TreeDetector/CollisionShape2D.shape.extents.y = length
	$TreeDetector.drop_trees()
	set_current_length(length)

func set_width(width: float):
	self.width = width
	$TreeDetector/CollisionShape2D.shape.extents.x = width
	$TreeDetector.drop_trees()
	set_current_width(width)

func set_current_width(width: float):
	current_width = width

func set_current_length(length: float):
	current_length = length

func update_trees():
	$TreeDetector.update_trees(current_width, current_length)
