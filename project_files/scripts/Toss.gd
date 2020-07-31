# Toss.gd
class_name Toss
extends Component



onready var timer = Timer.new()



func _ready():
	timer.set_one_shot(true)
	add_child(timer)


func toss(go):
	pass
