# Grave.gd
class_name Grave
extends GameObject



const GOLD = preload("res://game_objects/Gold.tscn")
const ZOMBIE = preload("res://game_objects/Zombie.tscn")
const AMMO = preload("res://game_objects/Ammo.tscn")
const GUN = preload("res://game_objects/Gun.tscn")


var rng = RandomNumberGenerator.new()



var cemetery
var map_pos



var opened_once = false
var item_id = 0
var closed = true



onready var spawn_zombie_timer = Timer.new()
export(float) var spawn_zombie_wait_time = 2

# for now (item IDs):
# 60 % chance no spawn = 0
# 10 % gold = 1
# 20 % weapon = 2



func create(_cemetery, _map_pos):
	cemetery = _cemetery
	map_pos = _map_pos



func _ready():
	rng.randomize()
	global_transform = cemetery.tile_map.get_world_transform(map_pos)
	spawn_zombie_timer.set_wait_time(spawn_zombie_wait_time)
	spawn_zombie_timer.set_one_shot(true)
	add_child(spawn_zombie_timer)
	spawn_zombie_timer.connect("timeout", self, "spawn_zombie")
	
	var rand = rng.randf() * 100.0
	if rand > 90:
		item_id = 1
		#gold
	elif rand > 70:
		item_id = 2
		# gun


func toggle_open():
	if closed:
		closed = false
		
		if !opened_once:
			opened_once = true
			
			spawn_zombie_timer.start()
			
			var flip_x = cemetery.tile_map.get_flip_x(global_transform)
			var flip_y = cemetery.tile_map.get_flip_y(global_transform)
			var transpose = cemetery.tile_map.get_transposed(global_transform)
			
			cemetery.tile_map.set_cell(map_pos.x, map_pos.y, main.CASKET_ID, flip_x, flip_y, transpose)
			
			if item_id != 0:
				var drop
				
				match item_id:
					1:
						drop = GOLD.instance()
					2:
						drop = GUN.instance()
					
				drop.transform.origin = cemetery.tile_map.map_to_world(get_spawn_coords())
				game_world.add_game_object(drop)
	else:
		closed = true



func spawn_zombie():
	var zombie = ZOMBIE.instance()
	zombie.create(cemetery)
	zombie.transform.origin = cemetery.tile_map.map_to_world(get_spawn_coords())
	
	#zombie.NAV
	
	game_world.add_game_object(zombie)
	
	spawn_zombie_timer.queue_free()



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
