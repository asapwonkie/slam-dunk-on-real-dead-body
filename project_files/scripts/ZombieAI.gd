# ZombieAI.gd
class_name ZombieAI
extends Component



onready var nav = game_object.get_parent().get_child_of_type(Navigation2D)
onready var player = get_node("/root/Main/World/Player")
onready var character_controller = game_object.get_child_of_type(CharacterController)



func _process(_delta):
	if game_object.get_parent().get_child_of_type(TileMap).is_near(game_object.global_position, player.global_position, Vector2(2, 2)):
		var path_to_player = nav.get_simple_path(game_object.global_position, player.global_position)
		game_object.get_child_of_type(Line2D).points = path_to_player
		var direction = (path_to_player[1] - game_object.global_position).normalized()
		character_controller.walk(direction)
	else:
		game_object.get_child_of_type(Line2D).points = [ ]
