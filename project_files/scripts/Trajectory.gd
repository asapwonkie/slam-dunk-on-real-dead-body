# Trajectory.gd
class_name Trajectory
extends GameObject



var phi = 0
var current_x = 0



func create(_phi, _initial_x):
	phi = _phi
	current_x = _initial_x
	
	
func set_angle(_phi):
	phi = _phi


func _process(_delta):
	self.points = sample(10)
	if Input.is_action_just_pressed("Debug"):
		print(self.points)

func f(_x):
	var y = sqrt( (1 - pow(_x,2)) / 2 )
	if phi >= 0 and phi <= PI:
		y *= -1
	return y

func get_value_at_x(_x):
	if phi >= 0 and phi <= PI:
#		var T = -2*phi/PI+1
#		var H = (1/8) * pow(abs(_x), (80/100))
#
#		var a = H / (pow(T/2, 2))
#		var b = H
#		var c = T / 2
#
#		return -(a * pow(_x-c, 2)) + b
		return f(cos(phi))/cos(phi) * (_x - cos(phi)) + f(cos(phi))
	elif phi < 0 and phi > PI:
		return -1

func get_end_point_x():
	return cos(phi)

func sample(num_points):
	var arr = []
	var x = 0
	var y = 0
	
	for n in range(num_points+1):
		x = n * get_end_point_x() / num_points
		#y = get_value_at_x(x)
		y = f(x)
		arr.append(16 * Vector2(x, -y))
	
	return arr

func advance(dx):
	current_x += dx
	
	var end_point_x = get_end_point_x()
	if end_point_x < 0:
		current_x = clamp(current_x, end_point_x, 0)
	else:
		current_x = clamp(current_x, 0, end_point_x)
	
func get_value():
	return get_value_at_x(current_x)
