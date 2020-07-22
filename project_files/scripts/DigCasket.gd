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
		var map_pos = cemetery_tile_map.world_to_map(grave.get_child_of_type(Sprite).transform.origin)
		cemetery_tile_map.set_cell(map_pos.x, map_pos.y, -1)
		print(map_pos)
