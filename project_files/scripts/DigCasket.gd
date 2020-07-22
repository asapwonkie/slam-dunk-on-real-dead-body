# DigCasket.gd
class_name DigCasket
extends Component



# requires an Area2D



onready var area2D = game_object.get_child_of_type(Area2D)
onready var cemetery_tile_map = get_node("/root/Main/World/Cemetery/TileMap")



func dig():
	var overlapping_areas = area2D.get_overlapping_areas()
	
	if overlapping_areas.size() == 1:
		var grave = overlapping_areas[0].get_parent()
		var t = grave.get_child_of_type(Sprite).transform
		var map_pos = cemetery_tile_map.get_cell_pos(t, Vector2(3, 6))
		
		var flip_x = cemetery_tile_map.get_flip_x(t)
		var flip_y = cemetery_tile_map.get_flip_y(t)
		var transpose = cemetery_tile_map.get_transposed(t)
		
		cemetery_tile_map.set_cell(map_pos.x, map_pos.y, 5, flip_x, flip_y, transpose)
