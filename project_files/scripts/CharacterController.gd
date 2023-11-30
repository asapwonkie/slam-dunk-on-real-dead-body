class_name CharacterController
extends Component



# this component requires a CharacterBody2D



@export var walk_speed: int = 200
@export var stunned_speed: int = 125
@export var dash_speed: int = 500

@export var stunned_time: float = 0.3
@export var dash_time: float = 0.3
@export var dash_recover_time: float = 0.5

@export var aim_position_path: NodePath = "": set = set_aim_position_path


var walk_direction = Vector2.ZERO
var facing_direction = Vector2.ZERO
var walking = false
var knock_back_direction = Vector2.ZERO

var velocity = Vector2.ZERO



@onready var character_body2D = game_object.get_child_of_type(CharacterBody2D)

@onready var stunned_timer = Timer.new()
@onready var dash_timer = Timer.new()
@onready var dash_recover_timer = Timer.new()
@onready var knock_back_timer = Timer.new()

@onready var aim_position = game_object


func set_aim_position_path(path):
	if !path.is_empty():
		aim_position_path = path



func _ready():
	assert(character_body2D is CharacterBody2D)
	
	
	stunned_timer.set_wait_time(stunned_time)
	stunned_timer.set_one_shot(true)
	add_child(stunned_timer)
	
	dash_timer.set_wait_time(dash_time)
	dash_timer.set_one_shot(true)
	add_child(dash_timer)
	
	dash_recover_timer.set_wait_time(dash_recover_time)
	dash_recover_timer.set_one_shot(true)
	add_child(dash_recover_timer)
	
	knock_back_timer.set_one_shot(true)
	add_child(knock_back_timer)
	
	if !aim_position_path.is_empty():
		aim_position = get_node(aim_position_path)



func _process(_delta):
	if knock_back_direction != Vector2.ZERO and stunned_timer.is_stopped():
		knock_back_direction = Vector2.ZERO



func _physics_process(_delta):
	facing_direction = (game_object.get_global_mouse_position() - aim_position.global_position).normalized()
	velocity = get_move_velocity()
	character_body2D.set_velocity(velocity)
	character_body2D.move_and_slide()



func get_move_velocity():
	if !stunned_timer.is_stopped():
		return knock_back_direction * stunned_speed
	else:
		var move_direction = walk_direction
		
		# if there is a barrier north of you and you are moving up and to the left, just move left
		if move_direction.x != 0 and move_direction.y != 0 and character_body2D.test_move(character_body2D.global_transform, move_direction):
			move_direction = move_direction / Vector2(abs(move_direction.x), abs(move_direction.y))
			if !character_body2D.test_move(character_body2D.global_transform, Vector2(move_direction.x, 0)):
				move_direction.y = 0
			elif !character_body2D.test_move(character_body2D.global_transform, Vector2(0, move_direction.y)):
				move_direction.x = 0
		
		if !dash_timer.is_stopped():
			return move_direction * dash_speed
		elif walking:
			return move_direction * walk_speed
		else:
			return Vector2.ZERO


# this is never referenced; why is this here?
#func get_class():
	#return "This doesn't work anymore"#"CharacterController"



func is_stunned():
	return !stunned_timer.is_stopped()



func stun():
	stunned_timer.start()
	dash_timer.stop()



func knock_back(direction: Vector2, time: float):
	knock_back_direction = direction.normalized()
	knock_back_timer.set_wait_time(time)
	knock_back_timer.start()



func is_dashing():
	return !dash_timer.is_stopped()



func can_dash():
	return !is_dashing() and dash_recover_timer.is_stopped() and !is_stunned()



func dash():
	if can_dash():
		dash_timer.start()
		dash_recover_timer.start()



func walk(direction: Vector2):
	walking = false
	if direction != Vector2.ZERO and !is_dashing():
		walking = true
		walk_direction = direction.normalized()
