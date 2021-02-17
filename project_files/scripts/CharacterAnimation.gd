# CharacterAnimation.gd
class_name CharacterAnimation
extends Component



# this component requires:
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

var facing_direction = "right"

var injected_anim = ""
var playing_injected_anim = false


onready var sprite = game_object.get_child_of_name("CharacterSprite")
onready var animation_player = game_object.get_child_of_type(AnimationPlayer)
onready var kinematic_body2D = game_object.get_child_of_type(KinematicBody2D)
onready var character_controller = game_object.get_child_of_type(CharacterController)
onready var inventory = game_object.get_child_of_type(Inventory)


func _ready():
	animation_player.play("idleright")
	animation_player.connect("animation_finished", self, "animation_finished")



func _process(_delta):
	if !playing_injected_anim:
		var card_dir = get_cardinal_direction(character_controller.facing_direction)
		
		if card_dir == "right":
			facing_direction = "right"
		elif card_dir == "left":
			facing_direction = "left"
			
		if inventory.primary == null:
			animation_player.play(str("idle", facing_direction))
		elif inventory.primary is Shovel:
			animation_player.play(str("idle", facing_direction, "shovel"))
		elif inventory.primary is Gun:
			animation_player.play(str("idle", facing_direction, "gun"))

#	if character_controller.walking:
#		if animation_player.current_animation != str("walk", facing_direction):
#			animation_player.play(str("walk", facing_direction))
#	else:
#		if animation_player.current_animation != str("idle", facing_direction):
#			animation_player.play(str("idle", facing_direction))



func get_cardinal_direction(vec2):
	var degrees = vec2.angle() * 360 / (2 * PI)
	
	if degrees < -45 and degrees > -135:
		return "up"
	elif degrees > -45 and degrees < 45:
		return "right"
	elif degrees > 45 and degrees < 135:
		return "down"
	elif (degrees > 135 and degrees <= 180) or (degrees < -135 and degrees > -180):
		return "left"


func animation_finished(anim_name):
	if anim_name == injected_anim:
		injected_anim = ""
		playing_injected_anim = false



func dig():
	injected_anim = str("idle", facing_direction, "shovel", "dig")
	playing_injected_anim = true
	animation_player.play(injected_anim)



func swing():
	injected_anim = str("idle", facing_direction, "shovel", "swing")
	playing_injected_anim = true
	animation_player.play(injected_anim)
