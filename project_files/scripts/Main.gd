# Main.gd
extends Node

const CELL_SIZE = 16
const PATH_ID = 1
const PATH_SIZE = 3
const BARRIER_LAYER = 1


const GameWorldPreload = preload("res://scenes/GameWorld.tscn")

onready var GameWorld = get_node("/root/Main/GameWorld")
onready var Console = get_node("/root/Main/GUI/Console")
onready var fps_label = get_node("/root/Main/GUI/FPSLabel")

var draw_zombie_paths_value = false



var rng = RandomNumberGenerator.new()



func _ready():
	rng.randomize()



func quit():
	get_tree().quit()



func restart():
	get_node("/root/Main/GameWorld").free()
	get_node("/root/Main").add_child(GameWorldPreload.instance())



func showfps(value):
	if value == "0" or value == "1":
		fps_label.visible = int(value)
	else:
		Console.print_error("Error: Expected value of 0 or 1.")



func timescale(value):
	if float(value) > 0:
		Engine.time_scale = float(value)
	else:
		Console.print_error("Error: Expected value greater than 0.")



func draw_zombie_paths(value):
	if value == "0" or value == "1":
		draw_zombie_paths_value = int(value)
	else:
		Console.print_error("Error: Expected value of 0 or 1.")
