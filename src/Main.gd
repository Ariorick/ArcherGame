extends Node2D
class_name Main

func _ready():
	init_console()
	Saver.load_game()

func init_console():
	Console.add_command('add', ConsoleExtensions, 'add_by_id')\
		.set_description('Adds %amount% of %resource_name% to inventory.')\
		.add_argument('resource_name', TYPE_STRING)\
		.add_argument('amount', TYPE_INT)\
		.register()
	
	Console.add_command('recipies', ConsoleExtensions, 'print_recipies')\
		.set_description('Returns recepies.')\
		.register()
	
	Console.add_command('types', ConsoleExtensions, 'print_item_types')\
		.set_description('Returns recepies.')\
		.register()
	
	Console.add_command('craft', ConsoleExtensions, 'craft')\
		.set_description('Tries to crafts item from inventory.')\
		.add_argument('resource_name', TYPE_STRING)\
		.add_argument('amount', TYPE_INT)\
		.register()
	
	Console.add_command('reset', self, 'reset')\
		.set_description('Removes save and resets player position')\
		.register()

func reset():
	Saver.delete_save()
	Inventory.set_items(Dictionary())
	GameManager.reset_player()
