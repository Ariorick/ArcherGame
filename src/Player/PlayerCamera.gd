extends Camera2D

func _ready():
	if current:
		CameraManager.current_camera = self

func _set_current(value: bool):
	._set_current(value)
	if current:
		CameraManager.current_camera = self
