# Shovel.gd
class_name Shovel
extends GameObject



func dig(dig_box: Area2D):
	var overlapping_areas = dig_box.get_overlapping_areas()
	
	if overlapping_areas.size() == 1:
		var grave = get_game_object(overlapping_areas[0])
		#print(grave.name)
		grave.open()
