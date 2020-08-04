# Shovel.gd
class_name Shovel
extends GameObject



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
