class_name LoadCemetery
extends Component



const GRAVE = preload("res://game_objects/Grave.tscn")



onready var tile_map = game_object.get_child_of_type(TileMap)



func _ready():
	#tile_map.visible = false
	load_objects()



func load_objects():
	var used_cells_pos = tile_map.get_used_cells()
	var tile_name = ""
	
	for pos in used_cells_pos:
		tile_name = tile_map.tile_set.tile_get_name(tile_map.get_cellv(pos))
		
		if tile_name == "grave":
			var grave = GRAVE.instance()
			var sprite = grave.get_child_of_type(Sprite)
			sprite.transform = tile_map.get_world_transform(pos, sprite.transform)
			game_object.call_deferred("add_child", grave)
