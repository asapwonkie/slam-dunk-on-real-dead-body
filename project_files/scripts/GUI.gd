# GUI.gd
class_name GUI
extends GameObject



@onready var console = get_child_of_type(Console)
@onready var fps_label = get_child_of_name("FPSLabel")
@onready var grave_image = get_child_of_name("GraveImage")


var fps_label_visible = false: set = set_fps_label_visible

func set_fps_label_visible(value):
	fps_label_visible = value
	fps_label.visible = value



var grave_image_visible = false: set = set_grave_image_visible

func set_grave_image_visible(value):
	grave_image_visible = value
	grave_image.visible = value
