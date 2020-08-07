# Shovel.gd
class_name Shovel
extends GameObject



var rigid_body


func _ready():
	rigid_body = $RigidBody2D
	
	
func _process(_delta):
	if Input.is_action_just_pressed("Debug"):
		print(global_position)
		print(rigid_body.global_position)


func dig(dig_box: Area2D):
	var overlapping_areas = dig_box.get_overlapping_areas()
	
	if overlapping_areas.size() == 1:
		var grave = get_game_object(overlapping_areas[0])
		grave.toggle_open()



func swing(melee_area):
	var overlapping_bodies = melee_area.get_overlapping_bodies()
	
	var go
	for body in overlapping_bodies:
		go = get_game_object(body)
		if go is Zombie:
			go.get_child_of_type(Health).hurt(1)


func set_collisions(value):
	pass
#	if value:
#		rigid_body.reset = true
#	else:
#		global_position = rigid_body.global_position
#		#remove_child(rigid_body)
#		rigid_body.reset = true
