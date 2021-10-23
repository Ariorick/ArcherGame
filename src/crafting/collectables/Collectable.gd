extends Area2D
class_name Collectable

var orientation := Vector2(sign(rand_range(-1, 1)), 1)
var close_to_player := false
var mouse_hovered := false
var picked := false

export(String, FILE, "*.json") var item_json: String

func on_clicked():
	_add_item()
	queue_free()

func condition() -> bool:
	return true

func _add_item():
	Inventory.add(ItemFilesUtils.id_from_path(item_json))

func _on_Collectable_input_event(viewport, event, shape_idx):
	if not picked and condition() and Input.is_action_just_pressed("attack") \
			and mouse_hovered and close_to_player:
		picked = true
		on_clicked()
		update_state()

func update_state():
	if picked:
		$Visuals.material.set_shader_param("color", Color(1, 1, 1, 0))
		return
	
	if close_to_player:
		$Visuals.material.set_shader_param("color", Color(1, 1, 1, .25))
		if mouse_hovered:
			$Visuals.material.set_shader_param("color", Color(1, 1, 1, .6))
	else:
		$Visuals.material.set_shader_param("color", Color(1, 1, 1, 0))


func _ready():
	$Visuals.scale = orientation
	$Visuals.material.set_shader_param("enabled", true)
	update_state()

func _on_Collectable_mouse_entered():
	mouse_hovered = true
	update_state()

func _on_Collectable_mouse_exited():
	mouse_hovered = false
	update_state()

func _on_PlayerDetector_body_entered(body):
	if body is Player:
		close_to_player = true
		update_state()

func _on_PlayerDetector_body_exited(body):
	if body is Player:
		close_to_player = false
		update_state()
