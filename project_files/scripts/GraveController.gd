# GraveController.gd
class_name GraveController
extends Component



const GOLD = preload("res://game_objects/Gold.tscn")
const ZOMBIE = preload("res://game_objects/Zombie.tscn")
const CASKET_INDEX = 4
const GRAVE_SIZE = Vector2(48, 96)
const ZOMBIE_SIZE = Vector2(32, 32)



var cemetery
var zombie_inside = true



onready var timer = Timer.new()
export(float) var wait_time = 2



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
		
		spawn_gold()
		
			
func spawn_zombie():
	zombie_inside = false
	
	var zombie = ZOMBIE.instance()
	zombie.transform.origin = cemetery.get_child_of_type(TileMap).map_to_world(get_spawn_coords())
	
	cemetery.add_child(zombie)



func spawn_gold():
	var gold = GOLD.instance()
	gold.transform.origin = cemetery.get_child_of_type(TileMap).map_to_world(get_spawn_coords())
	cemetery.add_child(gold)



func get_spawn_coords():
	var tile_map = cemetery.get_child_of_type(TileMap)
	var map_pos = tile_map.get_cell_pos(game_object.global_transform, GRAVE_SIZE)
	
	if !tile_map.get_transposed(game_object.global_transform):
		if !tile_map.get_flip_y(game_object.global_transform):
			return map_pos + Vector2(2, 7)
		else:
			return map_pos + Vector2(2, -1)
	else:
		if !tile_map.get_flip_x(game_object.global_transform):
			return map_pos + Vector2(7, 1)
		else:
			return map_pos + Vector2(-1, 1)
