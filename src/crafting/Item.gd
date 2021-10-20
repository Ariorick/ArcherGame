class_name Item

var id: String # to a json
var name: String
var recipe: Dictionary # of ids to count
var count: int

func _init(path: String, count := 0):
	id = ItemFilesUtils.id_from_path(path)
	
	var file = File.new()
	file.open(path, file.READ)
	var json = file.get_as_text()
	file.close()
	
	var dict = parse_json(json)
	name = dict["name"]
	recipe = dict["recipe"]
	self.count = count
