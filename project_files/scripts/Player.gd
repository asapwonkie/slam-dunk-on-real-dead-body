# Player.gd

class_name Player
extends GameObject



onready var kinematic_body_2D = get_child_of_type(KinematicBody2D)


onready var head_position = get_child_of_name("HeadPosition")
onready var foot_position = get_child_of_name("FootPosition")

onready var hitbox = get_child_of_name("Hitbox")
onready var health = get_child_of_type(Health)

onready var sundown = get_child_of_name("Sundown")
var time = 0

#func set_noclip(value):
#	if value == true:
#		kinematic_body_2D.set_collision_mask_bit(1, false)
#	else:
#		pass

func _ready():
	sundown.material.set_shader_param("final_sundown_time", 5)
	sundown.material.set_shader_param("final_circle_time", 10)


func _process(delta):
	if health.health <= 0:
		main.restart()
		
	time += delta
	sundown.material.set_shader_param("current_time", time)
