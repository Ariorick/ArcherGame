extends Sprite
class_name TextureMap

onready var data: Image = texture.get_data()
onready var pixel_offset = texture.get_size() / 2

func _ready():
	data.lock()

func is_woods(v: Vector2):
	return _has_green(v)

func is_rocks(v: Vector2):
	return _is_black(v)

func has_background(v: Vector2):
	return is_woods(v) or is_rocks(v)

func _get_pixel(v: Vector2) -> Color:
	return data.get_pixelv(v + pixel_offset)

func _has_green(v: Vector2) -> bool:
	return _get_pixel(v).g > 0

func _has_blue(v: Vector2) -> bool:
	return _get_pixel(v).b > 0

func _has_red(v: Vector2) -> bool:
	return _get_pixel(v).r > 0

func _is_black(v: Vector2) -> bool:
	return _get_pixel(v) == Color.black
