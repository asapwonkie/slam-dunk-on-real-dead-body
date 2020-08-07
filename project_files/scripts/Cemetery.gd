# Cemetery.gd

class_name Cemetery
extends GameObject



const GRAVE = preload("res://game_objects/Grave.tscn")



onready var nav = get_child_of_type(Navigation2D)
onready var tile_map = get_child_of_type(TileMap)
onready var grave_holder = get_child_of_name("GraveHolder")



func _ready():
	#tile_map.visible = false
	create()



func create():
	var grave_positions = tile_map.get_used_cells_by_id(main.GRAVE_ID)
	var grave = null
	for pos in grave_positions:
		grave = GRAVE.instance()
		grave.create(self, pos)
		grave_holder.add_child(grave)
