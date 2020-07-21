class_name LoadCemetery
extends Component



const GRAVE = preload("res://game_objects/Grave.tscn")



onready var tile_map = game_object.get_child_of_type(TileMap)



func _ready():
	#tile_map.visible = false
	load_objects()



func load_objects():
	var used_cells_pos = tile_map.get_used_cells()
	
	var tile_id = 0
	var tile_name = ""
	for pos in used_cells_pos:
		tile_id = tile_map.get_cellv(pos)
		tile_name = tile_map.tile_set.tile_get_name(tile_id)
		
		if tile_name == "grave_up":
			var grave = GRAVE.instance()
			
			var grave_transform
			if !tile_map.is_cell_y_flipped(pos.x, pos.y):
				grave_transform = Transform2D(0, tile_map.map_to_world(pos))
			else:
				grave_transform = Transform2D(0, tile_map.map_to_world(pos + Vector2(3, 6)))
				grave_transform.x = Vector2(-1, 0)
				grave_transform.y = Vector2(0, -1)
			grave.get_child_of_type(StaticBody2D).transform = grave_transform
			
			game_object.call_deferred("add_child", grave)
		elif tile_name == "grave_right":
			var grave = GRAVE.instance()
			
			var grave_transform
			if !tile_map.is_cell_x_flipped(pos.x, pos.y):
				grave_transform = Transform2D(0, tile_map.map_to_world(pos + Vector2(6, 0)))
				grave_transform.x = Vector2(0, 1)
				grave_transform.y = Vector2(-1, 0)
			else:
				grave_transform = Transform2D(0, tile_map.map_to_world(pos + Vector2(0, 3)))
				grave_transform.x = Vector2(0, -1)
				grave_transform.y = Vector2(1, 0)
			grave.get_child_of_type(StaticBody2D).transform = grave_transform
			
			game_object.call_deferred("add_child", grave)
