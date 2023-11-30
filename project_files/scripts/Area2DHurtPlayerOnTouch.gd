class_name Area2DHurtPlayerOnTouch
extends Component


# this component requires:
#	- a parent Area2D with collision mask set to player
#	- a "player" GameObject in the tree with the following children:
#		- Area2D with collision layer set to player
#		- Health component
#		- KinematicBodyMovement component

# make sure to set the correct collision layer and mask for the parent and
# player Area2Ds, otherwise the Area2Ds will never overlap. by setting these,
# we are guaranteed to only collide with the player Area2D.



@export var damage_on_hit: int = 1



@onready var area2D = get_parent()



func _physics_process(_delta):
	var player
	var player_area2D
	var player_health
	var player_character_controller
	
	var overlapping_areas = area2D.get_overlapping_areas()
	
	# no need to loop if we have just 1 player
	player_area2D = overlapping_areas[0]
	player = get_game_object(player_area2D)
	player_health = player.get_child_of_type(Health)
	player_character_controller = player.get_child_of_type(CharacterController)
	
	player_health.hurt(damage_on_hit)
	player_character_controller.stun()
	player_character_controller.knock_back(player_area2D.global_position - area2D.global_position, 1)
