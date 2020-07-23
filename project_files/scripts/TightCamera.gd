# Camera which is tightly clamped to some node which moves during the
# _process() function. Normally cameras do not seem to update their
# position when the node they are following moves in the _process()
# function--this camera will follow the movements of such a node
# exactly, provided that the drag margins are set to 0.



# Note: Camera must be at the bottom of the scene hierarchy for this to work.



extends Camera2D



func _ready():
	set_process(true)



func _process(_delta):
	align()
