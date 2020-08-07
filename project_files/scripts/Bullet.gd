# Bullet.gd
class_name Bullet
extends GameObject



var damage = 1
var direction = Vector2.ZERO
var speed = 2000



#onready var hitbox = get_child_of_name("Hitbox")
onready var raycast = $RayCast2D
#onready var timer = Timer.new()



func fire(position, _direction, _damage):
	transform = transform.rotated(atan2(_direction.y, _direction.x))
	global_position = position
	direction = _direction
	damage = _damage



func _process(delta):
	var dx = direction * speed * delta
	raycast.cast_to = dx
	raycast.force_raycast_update()
	if raycast.is_colliding():
		global_position = raycast.get_collision_point()
		set_process(false)
		
		var go = get_game_object(raycast.get_collider())
		var health = go.get_child_of_type(Health)
		if health != null:
			health.hurt(damage)
			queue_free()
			
	else:
		global_position += dx
