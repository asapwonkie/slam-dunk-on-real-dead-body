class_name CharacterController
extends Component



# this component requires a KinematicBody2D



export(int) var walk_speed = 70
export(int) var stunned_speed = 125
export(int) var dash_speed = 200

export(float) var stunned_time = 0.3
export(float) var dash_time = 0.3
export(float) var dash_recover_time = 0.5



var walk_direction = Vector2.ZERO
var dash_direction = Vector2.ZERO
var knock_back_direction = Vector2.ZERO



onready var kinematic_body2D = game_object.get_child_of_type(KinematicBody2D)

onready var stunned_timer = Timer.new()
onready var dash_timer = Timer.new()
onready var dash_recover_timer = Timer.new()
onready var knock_back_timer = Timer.new()



func _ready():
	assert(kinematic_body2D is KinematicBody2D)
	
	
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



func _process(_delta):
	if knock_back_direction != Vector2.ZERO and stunned_timer.is_stopped():
		knock_back_direction = Vector2.ZERO



func _physics_process(_delta):
	kinematic_body2D.move_and_slide(get_move_direction())



func get_move_direction():
	if !dash_timer.is_stopped():
		return dash_direction * dash_speed
	elif !stunned_timer.is_stopped():
		return knock_back_direction * stunned_speed
	else:
		return walk_direction * walk_speed



func get_facing_direction():
	if !dash_timer.is_stopped():
		return dash_direction
	else:
		return walk_direction



func get_class():
	return "CharacterController"



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
	dash_direction = walk_direction
	dash_timer.start()
	dash_recover_timer.start()



func set_walk_direction(direction: Vector2):
	walk_direction = direction.normalized()
