class_name RandomMovement
extends Component



# this component requires a CharacterController



export(float) var move_time = 1



onready var character_controller = game_object.get_child_of_type(CharacterController)
onready var timer = Timer.new()



func _ready():
	assert(character_controller is CharacterController)
	
	timer.set_wait_time(move_time)
	timer.set_one_shot(true)
	add_child(timer)



func _process(_delta):
	if timer.is_stopped():
		var phi = rand_range(0, 2 * PI)
		character_controller.set_walk_direction(Vector2(cos(phi), sin(phi)))
		timer.start()
