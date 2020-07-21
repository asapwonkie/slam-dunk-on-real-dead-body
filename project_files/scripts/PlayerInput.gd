class_name PlayerInput
extends Component



# this component requires a CharacterController



export(String) var left_action = "ui_left"
export(String) var right_action = "ui_right"
export(String) var up_action = "ui_up"
export(String) var down_action = "ui_down"
export(String) var dash_action = "dash"
export(String) var attack_action = "a"



onready var character_controller = game_object.get_child_of_type(CharacterController)



func _process(_delta):
	character_controller.set_walk_direction(
			Vector2( -int(Input.is_action_pressed(left_action)) +
					  int(Input.is_action_pressed(right_action)),
					 -int(Input.is_action_pressed(up_action)) +
					  int(Input.is_action_pressed(down_action)) ))
		
	if Input.is_action_pressed(dash_action): # and stamina >= 20
		character_controller.dash()
