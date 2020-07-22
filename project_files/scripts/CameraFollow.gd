class_name CameraFollow
extends Component



# this component requires a TransformCoupling



onready var camera = get_node("/root/Main/Camera2D")
onready var transform_coupling = game_object.get_child_of_type(TransformCoupling)



func _ready():
	for i in range(transform_coupling.transform_holder_followers.size()):
		if transform_coupling.transform_holder_followers[i] == null:
			transform_coupling.transform_holder_followers[i] = camera
			return
	assert(false)
