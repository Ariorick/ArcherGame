extends Node2D
class_name Road

var length: float
var width: float
var current_width: float = 0.0

onready var tween: Tween = $Tween

func _ready():
	$TreeDetector/CollisionShape2D.shape.extents.y = length
	$TreeDetector/CollisionShape2D.shape.extents.x = width
	pass

func close():
	tween.interpolate_property(self, "current_width", 
		current_width, 0, 3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	current_width = 0

func open():
	tween.interpolate_property(self, "current_width", 
		current_width, width, 3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	current_width = width

func _process(delta):
	update_trees()
	update()

func _draw():
#	draw_rect(Rect2(0 - current_width, 0 - length, current_width * 2, length * 2), Color.white, false)
	pass

func update_trees():
	$TreeDetector.update_trees(current_width)
