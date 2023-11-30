# Zombie.gd
class_name Zombie
extends GameObject



var cemetery

@onready var player = get_node("/root/Main/GameWorld/Player")
@onready var character_controller = get_child_of_type(CharacterController)
@onready var hitbox = $Hitbox
@onready var health = $Health
@onready var inventory = $Inventory

var speed_curve = LogisticCurve.new()

var target_position = null



func create(_cemetery):
	cemetery = _cemetery



func _ready():
	speed_curve.create(150, 275, 0, 10, 0.5, 0.34)
	speed_curve.advance(10)


func _process(delta):
	character_controller.walk_speed = speed_curve.get_value()
	speed_curve.advance(-delta)
	
	var saw_player = false
	
	if can_see_player():
		saw_player = true
	
	if ( target_position == null
		 or global_position.distance_to(target_position) <= main.CELL_SIZE
		 or saw_player ):
		target_position = player.global_position
		
	if saw_player and inventory.primary is Gun:
		inventory.primary.aim(target_position - global_position)
		inventory.primary.shoot_bullet()
	
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
		var overlapping_health = go.get_child_of_type(Health)
		if overlapping_health != null:
			overlapping_health.hurt(1)
	
	if health.health == 0:
		queue_free()



func can_see_player():
	var space_state = get_world_2d().direct_space_state
	var query_head = PhysicsRayQueryParameters2D.create(global_position, player.head_position.global_position, main.BARRIER_LAYER)
	var query_mid = PhysicsRayQueryParameters2D.create(global_position, player.global_position, main.BARRIER_LAYER)
	var query_foot = PhysicsRayQueryParameters2D.create(global_position, player.foot_position.global_position, main.BARRIER_LAYER)
	return space_state.intersect_ray(query_head).is_empty() or space_state.intersect_ray(query_mid).is_empty() or space_state.intersect_ray(query_foot).is_empty()
