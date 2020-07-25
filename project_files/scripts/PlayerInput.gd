class_name PlayerInput
extends Component



# this component requires a CharacterController



export(String) var left_action = "Left"
export(String) var right_action = "Right"
export(String) var up_action = "Up"
export(String) var down_action = "Down"
export(String) var dash_action = "Dash"
export(String) var use_action = "Use"
export(String) var equip_secondary_action = "EquipSecondary"
export(String) var drop_action = "Drop"
export(String) var pickup_action = "PickUp"



onready var character_controller = game_object.get_child_of_type(CharacterController)
onready var dig_box = game_object.get_child_of_name("DigBox")
onready var player_inventory = game_object.get_child_of_type(PlayerInventory)



func _process(_delta):
	character_controller.walk(
			Vector2( -int(Input.is_action_pressed(left_action)) +
					  int(Input.is_action_pressed(right_action)),
					 -int(Input.is_action_pressed(up_action)) +
					  int(Input.is_action_pressed(down_action)) ))
		
	if Input.is_action_pressed(dash_action): # and stamina >= 20
		character_controller.dash()
		
	if Input.is_action_just_pressed(use_action) and player_inventory.primary != null:
		if player_inventory.primary.name == "Shovel":
			player_inventory.primary.get_child_of_type(Dig).dig(dig_box)
		
	if Input.is_action_just_pressed(equip_secondary_action):
		player_inventory.switch_to_secondary()
		
	if Input.is_action_just_pressed(drop_action):
		player_inventory.drop_primary()
		
	if Input.is_action_just_pressed(pickup_action):
		player_inventory.pick_up()
