# Cemetery.gd

class_name Cemetery
extends GameObject



const GRAVE = preload("res://game_objects/Grave.tscn")
const GRAVE_INDEX = 0



onready var nav = get_child_of_type(Navigation2D)
onready var tile_map = get_child_of_type(TileMap)
onready var grave_holder = get_child_of_name("GraveHolder")



func _ready():
	#tile_map.visible = false
	create()



func create():
	var used_cells_pos = tile_map.get_used_cells()
	
	for pos in used_cells_pos:
		if tile_map.get_cellv(pos) == GRAVE_INDEX:
			var grave = GRAVE.instance()
			grave.create(self, pos)
			grave_holder.add_child(grave)
