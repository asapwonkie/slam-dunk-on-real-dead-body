# GraveController.gd
class_name GraveController
extends Component



const ZOMBIE = preload("res://game_objects/Zombie.tscn")
const CASKET_INDEX = 4
const GRAVE_SIZE = Vector2(48, 96)
const ZOMBIE_SIZE = Vector2(32, 32)



var cemetery
var zombie_inside = true



onready var timer = Timer.new()
export(float) var wait_time = 5



func load_grave(c, map_pos):
	cemetery = c
	game_object.global_transform = cemetery.get_child_of_type(TileMap).get_world_transform(map_pos)
	
	timer.set_wait_time(wait_time)
	timer.set_one_shot(true)
	add_child(timer)
	timer.connect("timeout", self, "spawn_zombie")



func open():
	if zombie_inside:
		timer.start()
		
		var tile_map = cemetery.get_child_of_type(TileMap)
		var map_pos = tile_map.get_cell_pos(game_object.global_transform, GRAVE_SIZE)
		
		var flip_x = tile_map.get_flip_x(game_object.global_transform)
		var flip_y = tile_map.get_flip_y(game_object.global_transform)
		var transpose = tile_map.get_transposed(game_object.global_transform)
		
		tile_map.set_cell(map_pos.x, map_pos.y, CASKET_INDEX, flip_x, flip_y, transpose)
			
		
			
func spawn_zombie():
	zombie_inside = false
	
	var zombie = ZOMBIE.instance()
	
	var tile_map = cemetery.get_child_of_type(TileMap)
	var map_pos = tile_map.get_cell_pos(game_object.global_transform, GRAVE_SIZE)
	
	var spawn_coords
	if !tile_map.get_transposed(game_object.global_transform):
		if !tile_map.get_flip_y(game_object.global_transform):
			spawn_coords = map_pos + Vector2(2, 7)
		else:
			spawn_coords = map_pos + Vector2(2, -1)
	else:
		if !tile_map.get_flip_x(game_object.global_transform):
			spawn_coords = map_pos + Vector2(7, 1)
		else:
			spawn_coords = map_pos + Vector2(-1, 1)
			
	zombie.transform.origin = tile_map.map_to_world(spawn_coords)
	cemetery.add_child(zombie)
