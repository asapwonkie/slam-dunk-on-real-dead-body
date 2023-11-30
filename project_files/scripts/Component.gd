class_name Component
extends Node



#@onready var game_object = get_game_object(self.get_parent())
var game_object = null


var main = null
var game_world = null
#@onready var main = get_node("/root/Main")
#@onready var game_world = get_node("/root/Main/GameWorld")



func _enter_tree():
	game_object = get_game_object(self.get_parent())
	main = get_node("/root/Main")
	game_world = get_node("/root/Main/GameWorld")



func get_game_object(node) -> GameObject:
	if node is GameObject:
		return node
	else:
		return get_game_object(node.get_parent())
