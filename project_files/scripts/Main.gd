# Main.gd
extends Node

const CELL_SIZE = 16
const PATH_ID = 1
const PATH_SIZE = 3
const BARRIER_LAYER = 1
const CASKET_INDEX = 4
const GRAVE_SIZE = Vector2(48, 96)
const ZOMBIE_SIZE = Vector2(32, 32)

const MAP_Z_INDEX = -5
const PLAYER_Z_INDEX = 0


const GAMEWORLD = preload("res://scenes/GameWorld.tscn")
const GUN = preload("res://game_objects/Gun.tscn")

onready var GameWorld = get_node("/root/Main/GameWorld")
onready var player = get_node("/root/Main/GameWorld/Player")
onready var Console = get_node("/root/Main/GUI/Console")
onready var fps_label = get_node("/root/Main/GUI/FPSLabel")

var draw_zombie_paths_value = false



func quit():
	get_tree().quit()



func restart():
	get_node("/root/Main/GameWorld").free()
	get_node("/root/Main").add_child(GAMEWORLD.instance())



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



func give_gun():
	var player_inventory = player.get_child_of_type(PlayerInventory)
	var gun = GUN.instance()
	
	if player_inventory.primary == null:
		player_inventory.set_primary(gun)
	elif player_inventory.secondary == null:
		player_inventory.set_secondary(gun)
	else:
		player_inventory.drop_primary()
		player_inventory.set_primary(gun)
