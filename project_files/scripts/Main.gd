# Main.gd
extends Node

const CELL_SIZE = 16
const PATH_SIZE = 3
const BARRIER_LAYER = 1

const PATH_ID = 1
const GRAVE_ID = 0
const CASKET_ID = 4

const GRAVE_SIZE = Vector2(48, 96)
const ZOMBIE_SIZE = Vector2(32, 32)

const MAP_Z_INDEX = -5
const PLAYER_Z_INDEX = 0


const GAMEWORLD = preload("res://scenes/GameWorld.tscn")
const GUN = preload("res://game_objects/Gun.tscn")

onready var game_world = get_node("/root/Main/GameWorld")
onready var player = get_node("/root/Main/GameWorld/Player")
onready var console = get_node("/root/Main/GUI/Console")
onready var fps_label = get_node("/root/Main/GUI/FPSLabel")

var _draw_zombie_paths = false


func _ready():
	set_process(false)
	console.add_command("showfps", funcref(self, "set_showfps"), 1, [funcref(self, "get_showfps")])
	console.add_command("timescale", funcref(self, "set_timescale"), 1, [funcref(self, "get_timescale")])
	console.add_command("draw_zombie_paths", funcref(self, "set_draw_zombie_paths"), 1, [funcref(self, "get_draw_zombie_paths")])
	console.add_command("give_gun", funcref(self, "give_gun"), 0)
	console.add_command("invincible", funcref(self, "set_invincible"), 1, [funcref(self, "get_invincible")])


func _process(_delta):
	if !is_instance_valid(game_world):
		game_world = GAMEWORLD.instance()
		add_child(game_world)
		player = game_world.get_node("Player")
		set_process(false)


func quit():
	get_tree().quit()



func restart():
	game_world.queue_free()
	set_process(true)



func set_showfps(value):
	if value == "0" or value == "1":
		fps_label.visible = int(value)
	else:
		console.print_error("Error: Expected value of 0 or 1.")

func get_showfps():
	return fps_label.visible



func set_timescale(value):
	if float(value) > 0:
		Engine.time_scale = float(value)
	else:
		console.print_error("Error: Expected value greater than 0.")

func get_timescale():
	return Engine.time_scale


func set_draw_zombie_paths(value):
	if value == "0" or value == "1":
		_draw_zombie_paths = int(value)
	else:
		console.print_error("Error: Expected value of 0 or 1.")

func get_draw_zombie_paths():
	return _draw_zombie_paths


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


func set_invincible(value):
	if value == "0" or value == "1":
		player.get_child_of_type(Health).invincible = int(value)
	else:
		console.print_error("Error: Expected value of 0 or 1.")

func get_invincible():
	return player.get_child_of_type(Health).invincible
