class_name PlayerInput
extends Component



# this component requires a CharacterController



export(String) var left_action = "Left"
export(String) var right_action = "Right"
export(String) var up_action = "Up"
export(String) var down_action = "Down"
export(String) var dash_action = "Dash"
export(String) var attack_action = "a"
export(String) var dig_action = "Dig"



onready var character_controller = game_object.get_child_of_type(CharacterController)
onready var dig_casket = game_object.get_child_of_type(DigCasket)



func _process(_delta):
	character_controller.walk(
			Vector2( -int(Input.is_action_pressed(left_action)) +
					  int(Input.is_action_pressed(right_action)),
					 -int(Input.is_action_pressed(up_action)) +
					  int(Input.is_action_pressed(down_action)) ))
		
	if Input.is_action_pressed(dash_action): # and stamina >= 20
		character_controller.dash()
		
	if Input.is_action_just_pressed(dig_action):
		dig_casket.dig()
