@tool
# TransformCoupling.gd


class_name TransformCoupling
extends Node



var transform_holder_leader = null
var transform_holder_followers = [ null, null, null, null ]
var offsets = [ null, null, null, null ]



@export var transform_holder_leader_path: NodePath = NodePath(): set = set_transform_holder_leader_path

@export var transform_holder_follower_path_0: NodePath = NodePath(): set = set_transform_holder_follower_path_0
@export var offset_0: Vector2 = Vector2.ZERO

@export var transform_holder_follower_path_1: NodePath = NodePath(): set = set_transform_holder_follower_path_1
@export var offset_1: Vector2 = Vector2.ZERO

@export var transform_holder_follower_path_2: NodePath = NodePath(): set = set_transform_holder_follower_path_2
@export var offset_2: Vector2 = Vector2.ZERO

@export var transform_holder_follower_path_3: NodePath = NodePath(): set = set_transform_holder_follower_path_3
@export var offset_3: Vector2 = Vector2.ZERO


@export var couple_origin_x: bool = true
@export var couple_origin_y: bool = true
@export var couple_rotation: bool = true # measured CCW from +x axis
@export var couple_scale_x: bool = true
@export var couple_scale_y: bool = true
@export var couple_x_hat: bool = true
@export var couple_y_hat: bool = true



func _ready():
#	assert(transform_holder_leader_path != "")
#	assert(transform_holder_follower_path_0 != ""
#		or transform_holder_follower_path_1 != ""
#		or transform_holder_follower_path_2 != ""
#		or transform_holder_follower_path_3 != "")
	
	set_transforms()



func _process(_delta):
	if Engine.is_editor_hint():
		set_transforms()
		
	if transform_holder_leader != null:
		offsets = [ offset_0, offset_1, offset_2, offset_3 ]
	
		for i in range(transform_holder_followers.size()):
			if transform_holder_followers[i] != null:
				if couple_origin_x:
					transform_holder_followers[i].global_position.x = transform_holder_leader.global_position.x + offsets[i].x
				if couple_origin_y:
					transform_holder_followers[i].global_position.y = transform_holder_leader.global_position.y + offsets[i].y
				if couple_rotation:
					transform_holder_followers[i].global_transform.x = transform_holder_followers[i].global_scale.x * Vector2(cos(transform_holder_leader.global_rotation), sin(transform_holder_leader.global_rotation))
					transform_holder_followers[i].global_transform.y = transform_holder_followers[i].global_scale.y * Vector2(-sin(transform_holder_leader.global_rotation), cos(transform_holder_leader.global_rotation))
				if couple_scale_x:
					transform_holder_followers[i].global_transform.x = transform_holder_followers[i].global_transform.x.normalized() * transform_holder_leader.global_scale.x
				if couple_scale_y:
					transform_holder_followers[i].global_transform.y = transform_holder_followers[i].global_transform.y.normalized() * transform_holder_leader.global_scale.y
				if couple_x_hat:
					transform_holder_followers[i].global_transform.x = transform_holder_leader.global_transform.x
				if couple_y_hat:
					transform_holder_followers[i].global_transform.y = transform_holder_leader.global_transform.y



func set_transforms():
	if transform_holder_leader == null and !transform_holder_leader_path.is_empty():
		transform_holder_leader = get_node(transform_holder_leader_path)
	if transform_holder_followers[0] == null and !transform_holder_follower_path_0.is_empty():
		transform_holder_followers[0] = get_node(transform_holder_follower_path_0)
	if transform_holder_followers[1] == null and !transform_holder_follower_path_1.is_empty():
		transform_holder_followers[1] = get_node(transform_holder_follower_path_1)
	if transform_holder_followers[2] == null and !transform_holder_follower_path_2.is_empty():
		transform_holder_followers[2] = get_node(transform_holder_follower_path_2)
	if transform_holder_followers[3] == null and !transform_holder_follower_path_3.is_empty():
		transform_holder_followers[3] = get_node(transform_holder_follower_path_3)



func set_transform_holder_leader_path(path: NodePath) -> void:
	transform_holder_leader_path = path
	if path.is_empty():
		transform_holder_leader = null



func set_transform_holder_follower_path_0(path: NodePath) -> void:
	transform_holder_follower_path_0 = path
	if path.is_empty():
		transform_holder_followers[0] = null



func set_transform_holder_follower_path_1(path: NodePath) -> void:
	transform_holder_follower_path_1 = path
	if path.is_empty():
		transform_holder_followers[1] = null



func set_transform_holder_follower_path_2(path: NodePath) -> void:
	transform_holder_follower_path_2 = path
	if path.is_empty():
		transform_holder_followers[2] = null



func set_transform_holder_follower_path_3(path: NodePath) -> void:
	transform_holder_follower_path_3 = path
	if path.is_empty():
		transform_holder_followers[3] = null
