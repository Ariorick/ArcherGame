extends Interactable
class_name Collectable

const Minigame = preload("res://src/ui/minigame/Minigame.tscn")
const CollectedItem = preload("res://src/crafting/collectables/base/CollectedItem.tscn")

var orientation := Vector2(sign(rand_range(-1, 1)), 1)
var picked := false
var minigame : Minigame = null

export(String, FILE, "*.json") var item_json: String
var item_id: String

func get_resource_texture() -> Texture:
	return load("res://assets/named/stone.png") as Texture

func on_collected():
	queue_free()

# override me if this resource can't be collected without a tool
func condition() -> bool:
	return true

func on_clicked():
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
	var collected_item = CollectedItem.instance()
	collected_item.item_id = item_id
	collected_item.amount = item_count
	get_parent().get_parent().add_child(collected_item)
	collected_item.global_position = global_position + Vector2(0, 0)
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
	item_id = ItemFilesUtils.id_from_path(item_json)
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
