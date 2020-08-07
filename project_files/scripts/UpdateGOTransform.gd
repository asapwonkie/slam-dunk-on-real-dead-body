# UpdateGOTransform.gd
class_name UpdateGOTransform
extends Component


# Note: does not work well with rigid bodies



export(NodePath) var node_from_path = NodePath() setget set_node_from_path
var node_from = null

export(bool) var enabled = true

export(bool) var couple_origin_x = true
export(bool) var couple_origin_y = true
export(bool) var couple_rotation = true # measured CCW from +x axis
export(bool) var couple_scale_x = true
export(bool) var couple_scale_y = true
export(bool) var couple_x_hat = true
export(bool) var couple_y_hat = true



func _ready():
	assert(node_from_path != "")
	set_node_from()



func _process(_delta):
	if node_from != null and node_from is RigidBody2D and Input.is_action_just_pressed("Debug"):
		print("hello")
		print(game_object.global_position)
		print(node_from.global_position)
	
	if enabled:
		if Engine.editor_hint:
			set_node_from()
	
		if node_from != null:
			if couple_origin_x:
				game_object.transform.origin.x = node_from.global_position.x
			if couple_origin_y:
				game_object.transform.origin.y = node_from.global_position.y
			if couple_rotation:
				game_object.transform.x = game_object.transform.x * Vector2(cos(node_from.global_rotation), sin(node_from.global_rotation))
				game_object.transform.y = game_object.transform.y * Vector2(-sin(node_from.global_rotation), cos(node_from.global_rotation))
			if couple_scale_x:
				game_object.transform.x = game_object.transform.x.normalized() * node_from.global_scale.x
			if couple_scale_y:
				game_object.transform.y = game_object.transform.y.normalized() * node_from.global_scale.y
			if couple_x_hat:
				game_object.transform.x = node_from.transform.x
			if couple_y_hat:
				game_object.transform.y = node_from.transform.y
			
			node_from.transform = Transform2D(0, Vector2.ZERO)



func set_node_from():
	if node_from == null and node_from_path != "":
		node_from = get_node(node_from_path)



func set_node_from_path(path: NodePath):
	node_from_path = path
	if path == "":
		node_from = null
