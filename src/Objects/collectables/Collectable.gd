extends Area2D
class_name Collectable

var close_to_player: bool = false
var mouse_hovered: bool = false

# This should be overriden
var item: int
export var itemm: int


func _on_Collectable_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("attack") and mouse_hovered and close_to_player:
		Inventory.add(item)

func update_state():
	if mouse_hovered:
		$Visuals.scale = Vector2(1.1, 1.1)
	else: 
		$Visuals.scale = Vector2(1.0, 1.0)
		
	$Visuals.material.set_shader_param("enabled", mouse_hovered and close_to_player)

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
