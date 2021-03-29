extends Node2D
class_name Circle


var radius: float
export var current_radius: float

func _ready():
#	$AnimationPlayer.play("TestRadius")
	pass

func _process(delta):
	$TreeDetector.update_trees(current_radius)

func set_radius(radius: float):
	self.radius = radius
	$TreeDetector/CollisionShape2D.shape.radius = radius
	set_current_radius(radius)

func set_current_radius(radius: float):
	current_radius = radius
	$TreeDetector.update_trees(radius)
