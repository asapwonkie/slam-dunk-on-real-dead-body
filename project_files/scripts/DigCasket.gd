# DigCasket.gd
class_name DigCasket
extends Component



# requires an Area2D called DigGraveArea2D



onready var area2D = game_object.get_child_of_name("DigGraveArea2D")



func dig():
	var overlapping_areas = area2D.get_overlapping_areas()
	
	if overlapping_areas.size() == 1:
		overlapping_areas[0].get_parent().get_child_of_type(GraveController).open()
