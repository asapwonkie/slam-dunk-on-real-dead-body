# Zombie.gd
class_name Zombie
extends GameObject



var cemetery

onready var player = get_node("/root/Main/GameWorld/Player")
onready var character_controller = get_child_of_type(CharacterController)
onready var hitbox = $Hitbox
onready var health = $Health


var hurt_timer = Timer.new()
var hurt_wait_time = 1 # seconds



var target_position = null


func create(_cemetery):
	cemetery = _cemetery



func _ready():
	hurt_timer.set_wait_time(hurt_wait_time)
	hurt_timer.set_one_shot(true)
	add_child(hurt_timer)


func _process(_delta):
	if ( target_position == null
		 or global_position.distance_to(target_position) <= 0.5 * Main.CELL_SIZE
		 or can_see_player() ):
		target_position = player.global_position
	
	var path = cemetery.nav.get_simple_path(global_position, target_position, false)
	if path.size() == 2:
		path.remove(1)
	path.append(target_position)
	
	if Main.draw_zombie_paths_value:
		$UpdateGOTransform/Line2D.points = path
	else:
		$UpdateGOTransform/Line2D.points = [ ]
		
	var direction = (path[1] - path[0]).normalized()
	character_controller.walk(direction)
	
	var overlapping_areas = hitbox.get_overlapping_areas()
	var go
	for area in overlapping_areas:
		go = get_game_object(area)
		if go is Bullet and go.active:
			go.active = false
			go.queue_free()
			health.hurt(1)
	
	if health.health == 0:
		queue_free()



func can_see_player():
	var space_state = get_world_2d().direct_space_state
	var result_head = space_state.intersect_ray(global_position, player.head_position.global_position, [], Main.BARRIER_LAYER)
	var result_mid = space_state.intersect_ray(global_position, player.global_position, [], Main.BARRIER_LAYER)
	var result_foot = space_state.intersect_ray(global_position, player.foot_position.global_position, [], Main.BARRIER_LAYER)
	return result_head.empty() or result_mid.empty() or result_foot.empty()
