# TileMapScript.gd
class_name TileMapScript
extends TileMap


@onready var Main = get_node("/root/Main")



func get_world_transform(pos):
	var id = get_cell_source_id(0, pos)
	# pos might need to be translated into something called atlas coords?
	var atlas_coords = get_cell_atlas_coords(1, pos)
	var size = tile_set.get_source(id).get_tile_texture_region(pos).size / Main.CELL_SIZE
	size = atlas_coords
	
	# workaround for testing whether or not cell is transposed in godot 4
	if (get_cell_alternative_tile(0, pos) & 1 << 14): # layer 0 or 1?
		# workaround for testing whether or not cell is y_flipped in godot 4
		if (get_cell_alternative_tile(0, pos) & 1 << 13):
			return Transform2D(0, map_to_local(pos))
		else:
			return Transform2D(3.14, map_to_local(pos + size))
	else:
		# workaround for testing whether or not cell is x_flipped in godot 4
		if (get_cell_alternative_tile(0, pos) & 1 << 12):
			return Transform2D(3.14/2, map_to_local(Vector2(pos.x + size.y, pos.y)))
		else:
			return Transform2D(-3.14/2, map_to_local(Vector2(pos.x, pos.y + size.x)))



func get_cell_pos(transform_from, size):
	var rot = transform_from.get_rotation()
	
	if is_equal_approx(rot, 0):
		return local_to_map(transform_from.origin)
	elif is_equal_approx(rot, 3.14/2):
		return local_to_map(transform_from.origin + Vector2(-size.y, 0))
	elif is_equal_approx(rot, 3.14):
		return local_to_map(transform_from.origin + Vector2(-size.x, -size.y))
	elif is_equal_approx(rot, -3.14/2):
		return local_to_map(transform_from.origin + Vector2(0, -size.x))



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
	var source_map_pos = local_to_map(source_global_position)
	var target_map_pos = local_to_map(target_global_position)
	var size = num_cells * 3
	
	return ( target_map_pos.x >= source_map_pos.x - size.x
			and target_map_pos.x <= source_map_pos.x + size.x
			and target_map_pos.y >= source_map_pos.y - size.y
			and target_map_pos.y <= source_map_pos.y + size.y )
