# PlayerInventory.gd
class_name PlayerInventory
extends Component



var primary = null
var secondary = null


onready var primary_position = game_object.get_child_of_name("HandPosition")
onready var secondary_position = game_object.get_child_of_name("BackPosition")



func _ready():
	if primary_position.get_children().size() == 1:
		primary = primary_position.get_child(0)
	if secondary_position.get_children().size() == 1:
		secondary = secondary_position.get_child(0)



func switch_to_secondary():
	if primary == null and secondary != null:
		primary = secondary
		secondary = null
		primary.z_index = 1
		secondary_position.remove_child(primary)
		primary_position.add_child(primary)
	elif primary != null and secondary == null:
		secondary = primary
		primary = null
		secondary.z_index = -1
		primary_position.remove_child(secondary)
		secondary_position.add_child(secondary)
	elif primary != null and secondary != null:
		var temp_primary = primary
		primary = secondary
		secondary = temp_primary
		primary.z_index = 1
		secondary.z_index = -1
		primary_position.remove_child(secondary)
		secondary_position.remove_child(primary)
		primary_position.add_child(primary)
		secondary_position.add_child(secondary)
