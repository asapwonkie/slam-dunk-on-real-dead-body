# GraveController.gd
class_name GraveController
extends Component



onready var transform_holder = game_object.get_child_of_type(TransformHolder)



var cemetery
var size = Vector2(48, 96)
var casket_index = 5



func load_grave(c, map_pos):
	cemetery = c
	transform_holder.transform = cemetery.get_node("TileMap").get_world_transform(map_pos)



func open():
	var tile_map = cemetery.get_node("TileMap")
	var map_pos = tile_map.get_cell_pos(transform_holder.transform, size)
	
	var flip_x = tile_map.get_flip_x(transform_holder.transform)
	var flip_y = tile_map.get_flip_y(transform_holder.transform)
	var transpose = tile_map.get_transposed(transform_holder.transform)
	
	tile_map.set_cell(map_pos.x, map_pos.y, casket_index, flip_x, flip_y, transpose)
