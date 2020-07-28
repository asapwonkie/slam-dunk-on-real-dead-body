# GameWorld.gd
class_name GameWorld
extends GameObject



var rng = RandomNumberGenerator.new()
const CELL_SIZE = 16
const PATH_ID = 1
const PATH_SIZE = 3
const BARRIER_LAYER = 1



func _ready():
	rng.randomize()
