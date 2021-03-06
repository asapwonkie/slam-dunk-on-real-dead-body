# TileMapScript.gd
class_name TileMapScript
extends TileMap


onready var Main = get_node("/root/Main")



func get_world_transform(pos):
	var id = get_cellv(pos)
	var size = tile_set.tile_get_region(id).size / Main.CELL_SIZE
	
	if !is_cell_transposed(pos.x, pos.y):
		if !is_cell_y_flipped(pos.x, pos.y):
			return Transform2D(0, map_to_world(pos))
		else:
			return Transform2D(3.14, map_to_world(pos + size))
	else:
		if is_cell_x_flipped(pos.x, pos.y):
			return Transform2D(3.14/2, map_to_world(pos + Vector2(size.y, 0)))
		else:
			return Transform2D(-3.14/2, map_to_world(pos + Vector2(0, size.x)))



func get_cell_pos(transform_from, size):
	var rot = transform_from.get_rotation()
	
	if is_equal_approx(rot, 0):
		return world_to_map(transform_from.origin)
	elif is_equal_approx(rot, 3.14/2):
		return world_to_map(transform_from.origin + Vector2(-size.y, 0))
	elif is_equal_approx(rot, 3.14):
		return world_to_map(transform_from.origin + Vector2(-size.x, -size.y))
	elif is_equal_approx(rot, -3.14/2):
		return world_to_map(transform_from.origin + Vector2(0, -size.x))



func get_flip_x(transform_from):
	var rot = transform_from.get_rotation()
	return is_equal_approx(rot, 3.14/2) or is_equal_approx(rot, 3.14)



func get_flip_y(transform_from):
	var rot = transform_from.get_rotation()
	return is_equal_approx(rot, 3.14) or is_equal_approx(rot, -3.14/2)



func get_transposed(transform_from):
	var rot = transform_from.get_rotation()
	return is_equal_approx(rot, 3.14/2) or is_equal_approx(rot, -3.14/2)



func is_near(source_global_position, target_global_position, num_cells):
	var source_map_pos = world_to_map(source_global_position)
	var target_map_pos = world_to_map(target_global_position)
	var size = num_cells * 3
	
	return ( target_map_pos.x >= source_map_pos.x - size.x
			and target_map_pos.x <= source_map_pos.x + size.x
			and target_map_pos.y >= source_map_pos.y - size.y
			and target_map_pos.y <= source_map_pos.y + size.y )
