# Gun.gd
class_name Gun
extends GameObject



const BULLET = preload("res://game_objects/Bullet.tscn")



export(float) var speed = 100



onready var bullet_holder = GameWorld.get_child_of_name("BulletHolder")



func shoot(direction, position = null):
	var b = BULLET.instance()
	b.create(direction, speed)
	
	if position == null:
		b.global_position = global_position
	else:
		b.global_position = position
		
	bullet_holder.add_child(b)
