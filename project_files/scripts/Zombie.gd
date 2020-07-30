# Zombie.gd
class_name Zombie
extends GameObject



var cemetery

onready var player = get_node("/root/Main/GameWorld/Player")
onready var character_controller = get_child_of_type(CharacterController)



var target_position = null


func create(_cemetery):
	cemetery = _cemetery



func _process(_delta):
	if can_see_player():
		target_position = player.global_position
	elif target_position == null or global_position.distance_to(target_position) <= 0.5 * go_world.CELL_SIZE:
		var path_tiles = cemetery.tile_map.get_used_cells_by_id(go_world.PATH_ID)
		var rand = go_world.rng.randi_range(0, path_tiles.size() - 1)
		target_position = cemetery.tile_map.map_to_world(path_tiles[rand]) + 0.5 * go_world.CELL_SIZE * go_world.PATH_SIZE * Vector2.ONE
		
	var path = cemetery.nav.get_simple_path(global_position, target_position, false)
	if path.size() == 2:
		path.remove(1)
	path.append(target_position)
	
	$UpdateGOTransform/Line2D.points = path
	var direction = (path[1] - path[0]).normalized()
	character_controller.walk(direction)



func can_see_player():
	var space_state = get_world_2d().direct_space_state
	var result_head = space_state.intersect_ray(global_position, player.head_position.global_position, [], go_world.BARRIER_LAYER)
	var result_mid = space_state.intersect_ray(global_position, player.global_position, [], go_world.BARRIER_LAYER)
	var result_foot = space_state.intersect_ray(global_position, player.foot_position.global_position, [], go_world.BARRIER_LAYER)
	return result_head.empty() or result_mid.empty() or result_foot.empty()
