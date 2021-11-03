class_name Item

var id: String # to a json
var name: String
var recipe: Dictionary # of ids to count
var count: int
var icon: String = "res://assets/named/item_placeholder.png"
var description: String = ""



func _init(id: String, count := 0):
	self.id = id
	
	var file = File.new()
	file.open(ItemFilesUtils.item_path_by_id(id), file.READ)
	var json = file.get_as_text()
	file.close()
	
	var dict = parse_json(json)
	name = dict["name"]
	if dict.has("recipe"):
		recipe = dict["recipe"]
	if dict.has("icon"):
		icon = dict["icon"]
	if dict.has("description"):
		description = dict["description"]
	self.count = count

# EXAMPLE json
#{
#    "name": "Pickaxe",
#    "description": "Allows you to mine rocks for stone and metal",
#    "icon": "res://assets/named/item_pickaxe.png",
#    "recipe": {
#            "stone": 5,
#            "stick": 5
#        }
#}
