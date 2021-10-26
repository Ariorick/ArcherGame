class_name Item

var id: String # to a json
var name: String
var recipe: Dictionary # of ids to count
var count: int
var icon: String = ""

func _init(id: String, count := 0):
	self.id = id
	
	var file = File.new()
	file.open(ItemFilesUtils.item_path_by_id(id), file.READ)
	var json = file.get_as_text()
	file.close()
	
	var dict = parse_json(json)
	name = dict["name"]
	recipe = dict["recipe"]
	if dict.has("icon"):
		icon = dict["icon"]
	self.count = count
