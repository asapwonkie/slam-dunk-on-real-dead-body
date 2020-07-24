# Dig.gd
class_name Dig
extends Component



func dig(dig_box: Area2D):
	var overlapping_areas = dig_box.get_overlapping_areas()
	
	if overlapping_areas.size() == 1:
		var grave = overlapping_areas[0].get_parent()
		grave.get_child_of_type(GraveController).open()
