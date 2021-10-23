extends Interactable
class_name Collectable

var orientation := Vector2(sign(rand_range(-1, 1)), 1)
var picked := false

export(String, FILE, "*.json") var item_json: String

func on_clicked():
	_add_item()
	queue_free()

func condition() -> bool:
	return true

func _add_item():
	Inventory.add(ItemFilesUtils.id_from_path(item_json))

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

func _on_Collectable_clicked(close_to_player):
	if not picked and condition() and close_to_player:
		picked = true
		on_clicked()
		update_state()

func _on_Collectable_state_changed(is_hovered, close_to_player):
	update_state()
