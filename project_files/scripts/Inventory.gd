# Inventory.gd
class_name Inventory
extends Component



# requires an Area2D named 'PickUpArea'
# requries two Position2Ds named 'PrimaryPosition' and 'SecondaryPosition'


var primary = null
var secondary = null

@export var primary_node_path: NodePath = "": set = set_primary_node_path
@export var secondary_node_path: NodePath = "": set = set_secondary_node_path



@onready var pickup_area = game_object.get_child_of_name("PickUpArea")
@onready var primary_position = game_object.get_child_of_name("PrimaryPosition")
@onready var secondary_position = game_object.get_child_of_name("SecondaryPosition")
@onready var character_controller = game_object.get_child_of_type(CharacterController)



var gold = 0



func set_primary_node_path(path):
	primary_node_path = path



func set_secondary_node_path(path):
	secondary_node_path = path



func _ready():
	if !primary_node_path.is_empty():
		set_primary(get_node(primary_node_path))
	if !secondary_node_path.is_empty():
		set_secondary(get_node(secondary_node_path))



func set_primary(go_primary):
	if go_primary == null:
		#primary.get_parent().call_deferred("remove_child", primary)
		primary = null
	else:
		primary = go_primary
		
		primary.transform = Transform2D(0, Vector2.ZERO)
		primary.z_index = 1
		
		var rigid_body = primary.get_child_of_type(RigidBody2D)
		if rigid_body != null:
			rigid_body.freeze = true
			rigid_body.transform = Transform2D(0, Vector2.ZERO)
		
		if go_primary.is_inside_tree():
			go_primary.get_parent().call_deferred("remove_child", go_primary)
			
		primary_position.call_deferred("add_child", primary)



func set_secondary(go_secondary):
	if go_secondary == null:
		secondary = null
	else:
		secondary = go_secondary
		
		secondary.transform = Transform2D(0, Vector2.ZERO)
		secondary.z_index = -1
		
		var rigid_body = primary.get_child_of_type(RigidBody2D)
		if rigid_body != null:
			rigid_body.freeze = true
			rigid_body.global_transform = primary.global_transform
		
		if go_secondary.is_inside_tree():
			go_secondary.get_parent().call_deferred("remove_child", go_secondary)
		
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
	var overlaps = pickup_area.get_overlapping_areas() + pickup_area.get_overlapping_bodies()
	var go = null
	var weapon_equipped = false
	
	for overlap in overlaps:
		go = get_game_object(overlap)
		if go is Shovel or go is Gun:
			if !weapon_equipped and go != primary and go != secondary:
				weapon_equipped = true
				
				if primary == null:
					set_primary(go)
				elif secondary == null:
					set_secondary(go)
				else:
					drop_primary()
					set_primary(go)
		elif go is Gold:
			go.queue_free()
			gold += 1
			print(str("Gold = ", gold))



func drop_primary():
	if primary != null:
		primary.transform = primary.global_transform
		primary_position.remove_child(primary)
		game_world.add_child(primary)
		
#		primary.set_collisions(true)
		var rigid_body = primary.get_child_of_type(RigidBody2D)
		if rigid_body != null:
			rigid_body.freeze = false
			rigid_body.apply_impulse(character_controller.velocity * 4 + character_controller.facing_direction * 1000, Vector2(1, 0))
		
		set_primary(null)
