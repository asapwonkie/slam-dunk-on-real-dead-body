# GameWorld.gd
class_name GameWorld
extends GameObject



onready var zombie_holder = get_node("ZombieHolder")
onready var item_holder = get_node("ItemHolder")
onready var bullet_holder = get_node("BulletHolder")



func add_game_object(go):
	if go is Zombie:
		zombie_holder.add_child(go)
	elif go is Bullet:
		bullet_holder.add_child(go)
	else:
		item_holder.add_child(go)
