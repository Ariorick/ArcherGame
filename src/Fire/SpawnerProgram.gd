class_name SpawnerProgram

const GHOST = "GHOST"
const MAGE = "MAGE"
const SKELLY = "SKELLY"

var chance_dict: Dictionary
var spawn_count: Dictionary

func _init(chance_dict, spawn_count):
	self.chance_dict = chance_dict
	self.spawn_count = spawn_count


#EXAMPLE
#
# chance_dict := {
#	SpawnerProgram.SKELLY: 1,
#	SpawnerProgram.GHOST: 1,
#	SpawnerProgram.MAGE: 1
# }


# it means that until $FIRST$ number of kills will be spawning max $SECOND$ enemies
# spawn_count := {
#	4: 2,
#	10: 3,
#	18: 4,
#	26: 5
# }
