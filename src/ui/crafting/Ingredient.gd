extends VBoxContainer

var icon: String
var count: int
var is_enough: bool

func _ready():
	$TextureRect.texture = load(icon)
	$Label.text = str(count)
	if is_enough:
		$Label.modulate = Color(0, 1, 0, 1)
	else:
		$Label.modulate = Color(1, 0, 0, 1)

