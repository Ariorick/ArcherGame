extends VBoxContainer

var icon: String
var count: int

func _ready():
	$TextureRect.texture = load(icon)
	$Label.text = str(count)

