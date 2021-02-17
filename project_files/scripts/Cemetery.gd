# Cemetery.gd

class_name Cemetery
extends GameObject



const GRAVE = preload("res://game_objects/Grave.tscn")



onready var nav = get_child_of_type(Navigation2D)
onready var tile_map = get_child_of_type(TileMap)
onready var grave_holder = get_child_of_name("GraveHolder")

var arr = []



func _ready():
	#tile_map.visible = false
	create_map()
	create_graves()

func create_map():
	pass
	#for i in range()

func create_graves():
	var grave_positions = tile_map.get_used_cells_by_id(main.GRAVE_ID)
	var grave = null
	for pos in grave_positions:
		grave = GRAVE.instance()
		grave.create(self, pos)
		grave_holder.add_child(grave)
