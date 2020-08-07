# SmoothCurve.gd
class_name SmoothCurve



# Values are between 0 and 1
# https://www.reddit.com/r/gamedev/comments/4xkx71/sigmoidlike_interpolation/



var initial_value = 0
var final_value = 0
var final_x = 0
var midpoint = 0
var steepness = 0

var x = 0



func create(_initial_value, _final_value, _final_x, _midpoint, _steepness):
	initial_value = _initial_value
	final_value = _final_value - _initial_value
	final_x = _final_x
	midpoint = _midpoint
	steepness = _steepness



func get_value_at(_x):
	var c = 2/(1-steepness)-1
	if _x <= 0:
		return 0
	elif _x < midpoint:
		return pow(_x, c)/pow(midpoint, c-1)
	elif _x == midpoint:
		return 0.5
	elif _x < midpoint*2:
		return 1 - pow(1-_x, c)/pow(1-midpoint, c-1)
	elif _x >= midpoint*2:
		return 1



func advance(dx):
	dx /= final_x
	x += dx
	x = clamp(x, 0, 1)



func get_value():
	return initial_value + get_value_at(x) * final_value
