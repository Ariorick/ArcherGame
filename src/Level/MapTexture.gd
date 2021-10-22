extends Sprite
class_name TextureMap

onready var data: Image = texture.get_data()
onready var pixel_offset = texture.get_size() / 2

func _ready():
	data.lock()

func is_woods1(v: Vector2) -> bool:
	return _has_green(v)

func is_woods2(v: Vector2) -> bool:
	return _has_red(v)

func _get_pixel(v: Vector2) -> Color:
	return data.get_pixelv(to_local(v) + pixel_offset)

func _has_green(v: Vector2) -> bool:
	return _get_pixel(v).g > 0

func _has_blue(v: Vector2) -> bool:
	return _get_pixel(v).b > 0

func _has_red(v: Vector2) -> bool:
	return _get_pixel(v).r > 0

func _is_black(v: Vector2) -> bool:
	return _get_pixel(v) == Color.black
