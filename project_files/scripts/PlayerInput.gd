class_name PlayerInput
extends Component



# this component requires a CharacterController



onready var character_controller = game_object.get_child_of_type(CharacterController)
onready var dig_box = game_object.get_child_of_name("DigBox")
onready var player_inventory = game_object.get_child_of_type(PlayerInventory)
onready var grave_image = get_node("/root/Main/GUI/GraveImage")
onready var melee_area = game_object.get_child_of_name("MeleeArea")
onready var character_animation = game_object.get_child_of_type(CharacterAnimation)



func _process(_delta):
	character_controller.walk(
			Vector2( -int(Input.is_action_pressed("Left")) +
					  int(Input.is_action_pressed("Right")),
					 -int(Input.is_action_pressed("Up")) +
					  int(Input.is_action_pressed("Down")) ))
					
	if get_node("/root/Main/GUI/GraveImage").visible:
		get_node("/root/Main/GUI/GraveImage").visible = !( Input.is_action_pressed("Left")
														or Input.is_action_pressed("Right")
														or Input.is_action_pressed("Up")
														or Input.is_action_pressed("Down") )
		
	if Input.is_action_pressed("Dash"): # and stamina >= 20
		character_controller.dash()
		
	if player_inventory.primary != null:
		if Input.is_action_just_pressed("Attack"):
			if player_inventory.primary is Shovel:
				player_inventory.primary.swing(melee_area)
				character_animation.swing()
			if player_inventory.primary is Gun:
				player_inventory.primary.shoot(character_controller.facing_direction, game_object.global_position)
		elif Input.is_action_just_pressed("Dig"):
			if player_inventory.primary is Shovel:
				player_inventory.primary.dig(dig_box)
				character_animation.dig()
		elif Input.is_action_just_released("Use"):
			if player_inventory.primary is Gun:
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
			get_node("/root/Main/GUI/GraveImage").visible = true
