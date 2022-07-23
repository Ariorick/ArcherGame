extends Sprite
class_name TextureMap

onready var data: Image = texture.get_data()
onready var pixel_offset = texture.get_size() / 2

export var enabled := true

func _ready():
	data.lock()
	

func is_woods1(v: Vector2) -> bool:
	return enabled and _has_green(v)
#	return enabled and (_has_green(v) or _has_red(v))

func is_woods2(v: Vector2) -> bool:
	return enabled and _has_red(v)
#	return false

func _get_pixel(v: Vector2) -> Color:
	var pixel = to_local(v) + pixel_offset
	var size = data.get_size()
	if pixel.x < size.x and pixel.y < size.y:
		return data.get_pixelv(pixel)
	else:
		return Color.black

func _has_green(v: Vector2) -> bool:
	return _get_pixel(v).g > 0

func _has_blue(v: Vector2) -> bool:
	return _get_pixel(v).b > 0

func _has_red(v: Vector2) -> bool:
	return _get_pixel(v).r > 0

func _is_black(v: Vector2) -> bool:
	return _get_pixel(v) == Color.black
