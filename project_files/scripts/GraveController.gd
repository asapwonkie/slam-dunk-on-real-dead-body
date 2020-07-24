# GraveController.gd
class_name GraveController
extends Component



const ZOMBIE = preload("res://game_objects/Zombie.tscn")



var cemetery
var size = Vector2(48, 96)
var casket_index = 4



func load_grave(c, map_pos):
	cemetery = c
	game_object.global_transform = cemetery.get_child_of_type(TileMap).get_world_transform(map_pos)



func open():
	var tile_map = cemetery.get_child_of_type(TileMap)
	var map_pos = tile_map.get_cell_pos(game_object.global_transform, size)
	
	var flip_x = tile_map.get_flip_x(game_object.global_transform)
	var flip_y = tile_map.get_flip_y(game_object.global_transform)
	var transpose = tile_map.get_transposed(game_object.global_transform)
	
	tile_map.set_cell(map_pos.x, map_pos.y, casket_index, flip_x, flip_y, transpose)
	
	var zombie = ZOMBIE.instance()
	zombie.transform.origin = tile_map.map_to_world(Vector2(30, 34))
	cemetery.add_child(zombie)
