class_name Item

var path: String # to a json
var name: String
var recipe: Dictionary # of paths to count
var count: int

func _init(path_to_json: String, count := 0):
	path = path_to_json
	
	var file = File.new()
	file.open(path, file.READ)
	var json = file.get_as_text()
	file.close()
	
	var dict = parse_json(json)
	name = dict["name"]
	recipe = dict["recipe"]
	self.count = count
