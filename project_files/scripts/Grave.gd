# Grave.gd
class_name Grave
extends GameObject



const GOLD = preload("res://game_objects/Gold.tscn")
const ZOMBIE = preload("res://game_objects/Zombie.tscn")
const CASKET_INDEX = 4
const GRAVE_SIZE = Vector2(48, 96)
const ZOMBIE_SIZE = Vector2(32, 32)



var cemetery
var map_pos
var zombie_inside = true


onready var timer = Timer.new()
export(float) var wait_time = 2



func create(_cemetery, _map_pos):
	cemetery = _cemetery
	map_pos = _map_pos



func _ready():
	global_transform = cemetery.tile_map.get_world_transform(map_pos)
	timer.set_wait_time(wait_time)
	timer.set_one_shot(true)
	add_child(timer)
	timer.connect("timeout", self, "spawn_zombie")



func open():
	if zombie_inside:
		timer.start()
		
		var flip_x = cemetery.tile_map.get_flip_x(global_transform)
		var flip_y = cemetery.tile_map.get_flip_y(global_transform)
		var transpose = cemetery.tile_map.get_transposed(global_transform)
		
		cemetery.tile_map.set_cell(map_pos.x, map_pos.y, CASKET_INDEX, flip_x, flip_y, transpose)
		
		spawn_gold()



func spawn_zombie():
	zombie_inside = false
	
	var zombie = ZOMBIE.instance()
	zombie.create(cemetery)
	zombie.transform.origin = cemetery.tile_map.map_to_world(get_spawn_coords())
	
	#zombie.NAV
	
	GameWorld.get_child_of_name("ZombieHolder").add_child(zombie)
	
	timer.queue_free()



func spawn_gold():
	var gold = GOLD.instance()
	gold.transform.origin = cemetery.tile_map.map_to_world(get_spawn_coords())
	GameWorld.get_child_of_name("ItemHolder").add_child(gold)



func get_spawn_coords():
	if !cemetery.tile_map.get_transposed(global_transform):
		if !cemetery.tile_map.get_flip_y(global_transform):
			return map_pos + Vector2(2, 7)
		else:
			return map_pos + Vector2(2, -1)
	else:
		if !cemetery.tile_map.get_flip_x(global_transform):
			return map_pos + Vector2(7, 1)
		else:
			return map_pos + Vector2(-1, 1)
