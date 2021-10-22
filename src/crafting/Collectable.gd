extends Area2D
class_name Collectable

var close_to_player: bool = false
var mouse_hovered: bool = false

export(String, FILE, "*.json") var item_json: String

func _on_Collectable_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("attack") and mouse_hovered and close_to_player:
		Inventory.add(ItemFilesUtils.id_from_path(item_json))
		queue_free()

func update_state():
	if close_to_player:
		$Visuals.material.set_shader_param("color", Color(1, 1, 1, .2))
		if mouse_hovered:
			$Visuals.material.set_shader_param("color", Color(1, 1, 1, .6))
	else:
		$Visuals.material.set_shader_param("color", Color(1, 1, 1, 0))
		
#	$Visuals.material.set_shader_param("enabled", mouse_hovered and close_to_player)

func _ready():
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
