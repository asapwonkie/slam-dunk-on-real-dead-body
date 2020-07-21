class_name PlayerAnimation
extends Component



# this component requires:
#	- a default texture
#	- a stunned texture
#	- Sprite
#	- KinematicBody2D
#	- CharacterController



# probably move this to a facing direction component or something
var dir_vec_to_str = { Vector2(-1, 0) : "left",
					   Vector2(1, 0)  : "right",
					   Vector2(0, -1) : "up", 
					   Vector2(0, 1)  : "down" }

var dir_str_to_vec = { "left"  : Vector2(-1, 0),
					   "right" : Vector2(1, 0),
					   "up"    : Vector2(0, -1),
					   "down"  : Vector2(0, 1) }



export(Resource) var default_texture
export(Resource) var stunned_texture



var was_stunned = false
var animation_direction = "down"



onready var sprite = game_object.get_child_of_type(Sprite)
onready var animation_player = game_object.get_child_of_type(AnimationPlayer)
onready var kinematic_body2D = game_object.get_child_of_type(KinematicBody2D)
onready var character_controller = game_object.get_child_of_type(CharacterController)



func _ready():
	assert(default_texture is Texture)
	assert(stunned_texture is Texture)
	assert(sprite is Sprite)
	assert(animation_player is AnimationPlayer)
	assert(kinematic_body2D is KinematicBody2D)
	assert(character_controller is CharacterController)

	animation_player.play("idledown")



func _process(_delta):
	# set animation_direction to the last cardinal direction the character walked in
	if dir_vec_to_str.has(character_controller.walk_direction):
		animation_direction = dir_vec_to_str.get(character_controller.walk_direction)


	# when not moving or when stunned, play idle animation
	if character_controller.walk_direction == Vector2.ZERO or character_controller.is_stunned():
		if animation_player.current_animation != str("idle", animation_direction):
			animation_player.play(str("idle", animation_direction))


	# when moving into a wall, play push animation
	elif kinematic_body2D.is_on_wall() and kinematic_body2D.test_move(kinematic_body2D.transform, dir_str_to_vec.get(animation_direction)):
		if animation_player.current_animation != str("push", animation_direction):
			animation_player.current_animation = str("push", animation_direction)


	# otherwise, if walking, play walk animation
	elif character_controller.walk_direction != Vector2.ZERO:
		if animation_player.current_animation != str("walk", animation_direction):
			animation_player.play(str("walk", animation_direction))


	# change textures if character was just stunned/unstunned
	if !was_stunned and character_controller.is_stunned():
		sprite.texture = stunned_texture
		was_stunned = true
	elif was_stunned and !character_controller.is_stunned():
		sprite.texture = default_texture
		was_stunned = false
