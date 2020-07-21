tool

class_name TransformCoupling
extends Component



var transform_holder_leader = null
var transform_holder_followers = [ null, null ]



export(NodePath) var transform_holder_leader_path = null setget set_transform_holder_leader_path, get_transform_holder_leader_path
export(NodePath) var transform_holder_follower_path_1 = null setget set_transform_holder_follower_path_1, get_transform_holder_follower_path_1
export(NodePath) var transform_holder_follower_path_2 = null setget set_transform_holder_follower_path_2, get_transform_holder_follower_path_2



export(bool) var couple_origin_x = false
export(bool) var couple_origin_y = false
export(bool) var couple_rotation = false # measured CCW from +x axis
export(bool) var couple_scale_x = false
export(bool) var couple_scale_y = false
export(bool) var couple_x_hat = false
export(bool) var couple_y_hat = false



func _ready():
	assert(transform_holder_leader_path != null)
	assert(transform_holder_follower_path_1 != null or transform_holder_follower_path_2 != null)
	
	transform_holder_leader = get_node(transform_holder_leader_path)
	
	if transform_holder_follower_path_1 != null:
		transform_holder_followers[0] = get_node(transform_holder_follower_path_1)

	if transform_holder_follower_path_2 != null:
		transform_holder_followers[1] = get_node(transform_holder_follower_path_2)



func _process(_delta):
	if Engine.editor_hint:
		if transform_holder_leader_path != "":
			transform_holder_leader = get_node(transform_holder_leader_path)
		if transform_holder_follower_path_1 != "":
			transform_holder_followers[0] = get_node(transform_holder_follower_path_1)
		if transform_holder_follower_path_2 != "":
			transform_holder_followers[1] = get_node(transform_holder_follower_path_2)
	
	for i in range(transform_holder_followers.size()):
		if transform_holder_followers[i] != null:
			if couple_origin_x:
				transform_holder_followers[i].transform.origin.x = transform_holder_leader.transform.origin.x
			if couple_origin_y:
				transform_holder_followers[i].transform.origin.y = transform_holder_leader.transform.origin.y
			if couple_rotation:
				transform_holder_followers[i].transform.x = transform_holder_followers[i].transform.get_scale().x * Vector2(cos(transform_holder_leader.transform.get_rotation()), sin(transform_holder_leader.transform.get_rotation()))
				transform_holder_followers[i].transform.y = transform_holder_followers[i].transform.get_scale().y * Vector2(-sin(transform_holder_leader.transform.get_rotation()), cos(transform_holder_leader.transform.get_rotation()))
			if couple_scale_x:
				transform_holder_followers[i].transform.x = transform_holder_followers[i].transform.x.normalized() * transform_holder_leader.transform.get_scale().x
			if couple_scale_y:
				transform_holder_followers[i].transform.y = transform_holder_followers[i].transform.y.normalized() * transform_holder_leader.transform.get_scale().y
			if couple_x_hat:
				transform_holder_followers[i].transform.x = transform_holder_leader.transform.x
			if couple_y_hat:
				transform_holder_followers[i].transform.y = transform_holder_leader.transform.y



func set_transform_holder_leader_path(path: NodePath) -> void:
	transform_holder_leader_path = path
	
func get_transform_holder_leader_path() -> NodePath:
	return transform_holder_leader_path



func set_transform_holder_follower_path_1(path: NodePath) -> void:
	transform_holder_follower_path_1 = path
	
func get_transform_holder_follower_path_1() -> NodePath:
	return transform_holder_follower_path_1



func set_transform_holder_follower_path_2(path: NodePath) -> void:
	transform_holder_follower_path_2 = path
	
func get_transform_holder_follower_path_2() -> NodePath:
	return transform_holder_follower_path_2
