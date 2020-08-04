# Gun.gd
class_name Gun
extends GameObject



const BULLET = preload("res://game_objects/Bullet.tscn")



var ammo = 10
var fire_rate = 0 # rounds per second


onready var bullet_holder = GameWorld.get_child_of_name("BulletHolder")



func shoot(direction, position = null):
	if ammo > 0:
		var b = BULLET.instance()
		b.create(direction)
		
		if position == null:
			b.global_position = global_position
		else:
			b.global_position = position
			
		bullet_holder.add_child(b)
		ammo -= 1



func stop_shooting():
	pass
