class_name PlayerInput
extends Component



# this component requires a CharacterController



onready var character_controller = game_object.get_child_of_type(CharacterController)
onready var dig_box = game_object.get_child_of_name("DigBox")
onready var player_inventory = game_object.get_child_of_type(PlayerInventory)
onready var melee_area = game_object.get_child_of_name("MeleeArea")
#onready var character_animation = game_object.get_component_of_type(CharacterAnimation)
onready var gui = main.get_child_of_type(GUI)



func _process(_delta):
	character_controller.walk(
			Vector2( -int(Input.is_action_pressed("Left")) +
					  int(Input.is_action_pressed("Right")),
					 -int(Input.is_action_pressed("Up")) +
					  int(Input.is_action_pressed("Down")) ))
					
	if gui.grave_image_visible:
		gui.grave_image_visible = !( Input.is_action_pressed("Left")
														or Input.is_action_pressed("Right")
														or Input.is_action_pressed("Up")
														or Input.is_action_pressed("Down") )
		
	if Input.is_action_pressed("Dash"): # and stamina >= 20
		character_controller.dash()
		
	var just_pressed_attack = Input.is_action_just_pressed("Attack")
	var just_released_attack = Input.is_action_just_released("Attack")
	var just_pressed_dig = Input.is_action_just_pressed("Dig")
		
	if player_inventory.primary is Shovel:
		if just_pressed_attack:
			player_inventory.primary.swing(melee_area)
			#character_animation.swing()
		elif just_pressed_dig:
			player_inventory.primary.dig(dig_box)
			#character_animation.dig()
	elif player_inventory.primary is Gun:
		player_inventory.primary.aim(character_controller.facing_direction)
		if just_pressed_attack:
			player_inventory.primary.start_shooting()
		elif just_released_attack:
			player_inventory.primary.stop_shooting()
		
	if Input.is_action_just_pressed("EquipSecondary"):
		player_inventory.switch_to_secondary()
		
	if Input.is_action_just_pressed("Drop"):
		player_inventory.drop_primary()
		
	if Input.is_action_just_pressed("PickUp"):
		player_inventory.pick_up()
		
	if Input.is_action_just_pressed("ShowGraveImage"):
		var overlapping_areas = dig_box.get_overlapping_areas()
		if overlapping_areas.size() >= 1:
			#var grave = get_game_object(dig_box.get_overlapping_areas()[0])
			gui.grave_image_visible = true
