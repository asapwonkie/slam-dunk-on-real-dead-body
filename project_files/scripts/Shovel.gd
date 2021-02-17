# Shovel.gd
class_name Shovel
extends GameObject



var rigid_body


func _ready():
	rigid_body = get_child_of_type(RigidBody2D)


func dig(dig_box: Area2D):
	var overlapping_areas = dig_box.get_overlapping_areas()
	
	if overlapping_areas.size() == 1:
		var grave = get_game_object(overlapping_areas[0])
		grave.toggle_open()



func swing(melee_area: Area2D):
	var overlapping_areas = melee_area.get_overlapping_areas()
	
	var go
	for area in overlapping_areas:
		go = get_game_object(area)
		if go is Zombie:
			go.get_child_of_type(Health).hurt(1)
			print("hit")
