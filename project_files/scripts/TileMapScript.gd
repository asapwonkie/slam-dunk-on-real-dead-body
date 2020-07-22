# TileMapScript.gd
class_name TileMapScript
extends TileMap



func get_world_transform(pos, transform_from):
	var id = get_cellv(pos)
	var size = tile_set.tile_get_region(id).size / cell_size
	
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
	
	size = size * cell_size
	
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
