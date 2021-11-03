extends Node
class_name TimeUtils

static func get_date_time_string():
	var time = OS.get_datetime()
	return str(time.day) + "." + str(time.month) + "." + str(time.year) + " " +\
		str(time.hour) + ":" + str(time.minute) + ":" + str(time.second)
