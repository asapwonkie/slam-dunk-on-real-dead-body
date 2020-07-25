# PlayerInventory.gd
class_name PlayerInventory
extends Component



# requires an Area2D named 'PickUpArea'
# requries two Position2Ds named 'PrimaryPosition' and 'SecondaryPosition'
var shovel


var primary = null
var secondary = null

export(NodePath) var primary_node_path = "" setget set_primary_node_path
export(NodePath) var secondary_node_path = "" setget set_secondary_node_path



onready var pickup_area = game_object.get_child_of_name("PickUpArea")
onready var primary_position = game_object.get_child_of_name("PrimaryPosition")
onready var secondary_position = game_object.get_child_of_name("SecondaryPosition")



var gold = 0



func set_primary_node_path(path):
	primary_node_path = path



func set_secondary_node_path(path):
	secondary_node_path = path



func _ready():
	if primary_node_path != "":
		set_primary(get_node(primary_node_path))
	if secondary_node_path != "":
		set_secondary(get_node(secondary_node_path))
	shovel = primary



func set_primary(game_object):
	if game_object == null:
		primary_position.remove_child(primary)
		primary = null
	else:
		primary = game_object
		
		primary.transform = Transform2D(0, Vector2.ZERO)
		primary.z_index = 1
		if game_object.is_inside_tree():
			game_object.get_parent().call_deferred("remove_child", game_object)
			
		primary_position.call_deferred("add_child", primary)



func set_secondary(game_object):
	if game_object == null:
		secondary_position.remove_child(secondary)
		secondary = null
	else:
		secondary = game_object
		
		secondary.transform = Transform2D(0, Vector2.ZERO)
		secondary.z_index = -1
		if game_object.is_inside_tree():
			game_object.get_parent().call_deferred("remove_child", game_object)
		
		secondary_position.call_deferred("add_child", secondary)



func switch_to_secondary():
	if primary == null and secondary != null:
		set_primary(secondary)
		set_secondary(null)
	elif primary != null and secondary == null:
		set_secondary(primary)
		set_primary(null)
	elif primary != null and secondary != null:
		var temp_primary = primary
		set_primary(secondary)
		set_secondary(temp_primary)



func pick_up():
	var overlapping_areas = pickup_area.get_overlapping_areas()
	var game_object = null
	
	for area in overlapping_areas:
		game_object = get_game_object(area)
		if game_object.has_child_of_type(Equippable):
			if game_object != primary and game_object != secondary:
				if primary == null:
					set_primary(get_game_object(area))
				elif secondary == null:
					set_secondary(get_game_object(area))
				break
		elif game_object.name == "Gold":
			game_object.queue_free()
			gold += 1
			print(gold)



func drop_primary():
	if primary != null:
		var temp_primary = primary
		temp_primary.transform = temp_primary.global_transform
		set_primary(null)
		get_node("/root/Main/World").add_child(temp_primary)
