extends Interactable
class_name Collectable

const Minigame = preload("res://src/ui/minigame/Minigame.tscn")

var orientation := Vector2(sign(rand_range(-1, 1)), 1)
var picked := false
var minigame : Minigame = null

export(String) var item_id: String
export(String) var instrument: String = "none"
export(int, 0, 2) var instrument_level: int = 0

func get_resource_texture() -> Texture:
	return load("res://assets/named/stone.png") as Texture

func on_collected():
	queue_free()

func need_instrument() -> bool:
	return instrument_level > 0

func can_be_collected() -> bool:
	return not need_instrument() or Inventory.instrument_level(instrument) >= instrument_level

func on_clicked():
	if need_instrument():
		open_minigame()
	else:
		Inventory.add(item_id)
		on_collected()

func open_minigame():
	minigame = Minigame.instance()
	minigame.item_id = item_id
	minigame.resource_texture = get_resource_texture()
	get_parent().get_parent().add_child(minigame)
	minigame.global_position = global_position + Vector2(0, -40)
	
	minigame.connect("sucess", self, "on_Minigame_sucess")
	minigame.connect("resource_destroyed", self, "on_Minigame_resource_destroyed")
	minigame.connect("resource_untouched", self, "on_Minigame_resource_untouched")

func on_Minigame_sucess(item_count):
	minigame = null
	Inventory.add(item_id, item_count)
	on_collected()
	
func on_Minigame_resource_destroyed():
	minigame = null
	queue_free()

func on_Minigame_resource_untouched():
#	Nothing happens i guess?
	picked = false
	minigame = null


func update_state():
	if not close_to_player and minigame != null:
		minigame.cancel()
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
	instrument.begins_with("")
	$Visuals.scale = orientation
	$Visuals.material.set_shader_param("enabled", true)
	update_state()

func _on_Collectable_clicked(close_to_player):
	if not picked and can_be_collected() and close_to_player:
		picked = true
		on_clicked()
		update_state()

func _on_Collectable_state_changed(is_hovered, close_to_player):
	update_state()
