# Player.gd

class_name Player
extends GameObject



onready var kinematic_body_2D = get_child_of_type(KinematicBody2D)


onready var head_position = get_child_of_name("HeadPosition")
onready var foot_position = get_child_of_name("FootPosition")

onready var hitbox = get_child_of_name("Hitbox")
onready var health = get_child_of_type(Health)


#func set_noclip(value):
#	if value == true:
#		kinematic_body_2D.set_collision_mask_bit(1, false)
#	else:
#		pass



func _process(_delta):
	var overlapping_bodies = hitbox.get_overlapping_bodies()
	var go
	for body in overlapping_bodies:
		go = get_game_object(body)
		if go is Zombie:
			health.hurt(1)
	
	if health.health == 0:
		Main.restart()
