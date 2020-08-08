# Zombie.gd
class_name Zombie
extends GameObject



var cemetery

onready var player = get_node("/root/Main/GameWorld/Player")
onready var character_controller = get_child_of_type(CharacterController)
onready var hitbox = $Hitbox
onready var health = $Health

var speed_curve = LogisticCurve.new()

var target_position = null



func create(_cemetery):
	cemetery = _cemetery



func _ready():
	speed_curve.create(150, 275, 10, 0.5, 0.34)
	speed_curve.advance(10)


func _process(delta):
	character_controller.walk_speed = speed_curve.get_value()
	speed_curve.advance(-delta)
	
	if ( target_position == null
		 or global_position.distance_to(target_position) <= main.CELL_SIZE
		 or can_see_player() ):
		target_position = player.global_position
	
	var path = cemetery.nav.get_simple_path(global_position, target_position, false)
	if path.size() == 2:
		path.remove(1)
	path.append(target_position)
	
	if main.get_draw_zombie_paths():
		$CharacterController/Line2D.points = path
	else:
		$CharacterController/Line2D.points = [ ]
		
	var direction = (path[1] - path[0]).normalized()
	character_controller.walk(direction)
	
	var overlapping_areas = hitbox.get_overlapping_areas()
	var go
	for area in overlapping_areas:
		go = get_game_object(area)
		var health = go.get_child_of_type(Health)
		if health != null:
			health.hurt(1)
	
	if health.health == 0:
		queue_free()



func can_see_player():
	var space_state = get_world_2d().direct_space_state
	var result_head = space_state.intersect_ray(global_position, player.head_position.global_position, [], main.BARRIER_LAYER)
	var result_mid = space_state.intersect_ray(global_position, player.global_position, [], main.BARRIER_LAYER)
	var result_foot = space_state.intersect_ray(global_position, player.foot_position.global_position, [], main.BARRIER_LAYER)
	return result_head.empty() or result_mid.empty() or result_foot.empty()
